import 'dart:ui';

import 'package:baustaka/config/client.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:baustaka/ui/map/map_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookingDetailsWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingDetailsWidget({
    super.key,
    required this.type,
    required this.withProduct,
  });

  @override
  String get tag => 'booking $type $withProduct';

  @override
  BookingController get controller => Get.put(
        BookingController(
          type: type,
          withProduct: withProduct,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => SlidingUpPanel(
        color: Colors.transparent,
        maxHeight: MediaQuery.of(screen.context).size.height * .5,
        minHeight: MediaQuery.of(screen.context).size.height * .5,
        panelBuilder: (sController) => PanelWidget(
          scrollController: sController,
          controller: controller,
          withProduct: withProduct,
          type: type,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        body: Stack(
          children: [
            Obx(
              () => MapWidget(
                markers: controller.pickers
                    .map(
                      (e) => Marker(
                        markerId: MarkerId(e.id!),
                        position: LatLng(
                          e.point!.coordinates![1],
                          e.point!.coordinates![0],
                        ),
                        infoWindow: InfoWindow(
                          title: e.user?.displayName,
                          snippet: '${e.mode?.capitalize} ${e.plate}',
                          onTap: () async =>
                              await Get.toNamed('${Routes.kPost}${e.id}'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      circularContainer(controller.color),
                      dashedContainer(Colors.grey.withOpacity(.4)),
                      borderContainer(),
                      dashedContainer(Colors.grey.withOpacity(.4)),
                      borderContainer(),
                      dashedContainer(Colors.grey.withOpacity(.4)),
                      borderContainer(),
                    ],
                  ),
                ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        border: const Border(
                          bottom: BorderSide(
                            width: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  var prediction =
                                      await PlacesAutocomplete.show(
                                    context: screen.context,
                                    apiKey: kGoogleApiKey,
                                    mode: Mode.overlay,
                                    overlayBorderRadius:
                                        BorderRadius.circular(8),
                                    components: [
                                      Component(Component.country, 'ke')
                                    ],
                                    strictbounds: false,
                                    types: [],
                                    proxyBaseUrl: kIsWeb ? kProxyBaseUrl : null,
                                  );

                                  if (prediction != null &&
                                      prediction.placeId != null) {
                                    final place = await GoogleMapsPlaces(
                                      apiKey: kGoogleApiKey,
                                      apiHeaders: await const GoogleApiHeaders()
                                          .getHeaders(),
                                      baseUrl: kIsWeb ? kProxyBaseUrl : null,
                                    ).getDetailsByPlaceId(prediction.placeId!);

                                    if (place.hasNoResults) {
                                      throw 'Something went wrong. Try again';
                                    }

                                    controller.data.update((val) {
                                      val!['area'] = prediction.description;
                                      val['latitude'] =
                                          place.result.geometry!.location.lat;
                                      val['longitude'] =
                                          place.result.geometry!.location.lng;
                                    });

                                    controller.updateLocation();
                                  }
                                } catch (e) {
                                  Util.toast(e);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.data.value['area'] ??
                                            'Search place',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          IconButton(
                            onPressed: () async {
                              await controller.updateCurrentLocation();

                              controller.updateLocation();
                            },
                            icon: Obx(
                              () => controller.isRequestingMyLocation.isTrue
                                  ? CircularProgressIndicator(
                                      color: controller.color,
                                    )
                                  : const Icon(
                                      Icons.my_location_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}

// ignore: must_be_immutable
class PanelWidget extends StatelessWidget {
  final String withProduct;
  final String type;
  final BookingController controller;
  final ScrollController scrollController;

  PanelWidget({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.withProduct,
    required this.type,
  });

  RxString selectedRadioTile = 'residential'.obs;

  setSelectedRadioTile(val) {
    selectedRadioTile.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const Gap(10),
            // drag handle bar
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .3,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Gap(30),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...kClients.map(
                    (e) => GestureDetector(
                      onTap: () => controller.data.update((val) {
                        val!['client'] = e;
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          border: Border(
                            top: BorderSide(
                              width: 2.0,
                              color: controller.color,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.home_outlined, size: 30),
                          title: TitleText(
                            text: e.capitalize!,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          trailing: Radio(
                            fillColor:
                                WidgetStateProperty.all(controller.color),
                            value: e,
                            groupValue: selectedRadioTile.value,
                            onChanged: (val) {
                              setSelectedRadioTile(val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.data.value['product'] == null &&
                      withProduct == 'yes' &&
                      type == 'disposal') {
                    Util.toast('Search subscription plan');
                  } else if (controller.data.value['area'] == null) {
                    Util.toast('Search place');
                  } else {
                    controller.bookingState.value = BookingState.kWaste;
                  }
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(controller.color),
                    foregroundColor: WidgetStateProperty.all(Colors.white)),
                child: const Text('Next step'),
              ),
            ),
            Expanded(child: Container()),
            Image.asset('assets/images/bottom_people.png'),
          ],
        ),
      ),
    );
  }
}



  // Container(
  //       color: controller.color,
  //       child: ClipRRect(
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(24),
  //           topRight: Radius.circular(24),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           color: Colors.white,
  //           child: SingleChildScrollView(
  //             key: const Key('booking_details'),
  //             child: Obx(
  //               () => Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                   if (withProduct == 'yes' && type == 'disposal') ...[
  //                     const Text(
  //                       'Subscription plan',
  //                       style: TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     GestureDetector(
  //                       onTap: () async {
  //                         try {
  //                           var product = await Get.toNamed(Routes.kProducts);

  //                           if (product != null) {
  //                             controller.data
  //                                 .update((val) => val!['product'] = product);
  //                           }
  //                         } catch (e) {
  //                           Util.toast(e);
  //                         }
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.grey.shade200,
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 12,
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             const Icon(Icons.search),
  //                             const SizedBox(
  //                               width: 8,
  //                             ),
  //                             Expanded(
  //                               child: Text(controller.data.value['product'] !=
  //                                       null
  //                                   ? '${(controller.data.value['product'] as Product).name} · ${(controller.data.value['product'] as Product).weeklyPickups}x weekly'
  //                                   : 'Search subscription plan'),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 32,
  //                     ),
  //                   ],
  //                   const Text(
  //                     'Booking for',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                   Obx(
  //                     () => Wrap(
  //                       spacing: 8,
  //                       runSpacing: 8,
  //                       children: [
  //                         ...kClients
  //                             .map(
  //                               (e) => GestureDetector(
  //                                 onTap: () => controller.data.update((val) {
  //                                   val!['client'] = e;
  //                                 }),
  //                                 child: Container(
  //                                   padding: const EdgeInsets.symmetric(
  //                                     horizontal: 16,
  //                                     vertical: 8,
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                     color:
  //                                         controller.data.value['client'] == e
  //                                             ? controller.color
  //                                             : Colors.grey.shade200,
  //                                     borderRadius: const BorderRadius.all(
  //                                       Radius.circular(8),
  //                                     ),
  //                                   ),
  //                                   child: Text(
  //                                     e.capitalize!,
  //                                     style: TextStyle(
  //                                       color:
  //                                           controller.data.value['client'] == e
  //                                               ? Colors.white
  //                                               : Colors.black,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                             .toList(),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 32,
  //                   ),
  //                   const Text(
  //                     'Pick up address',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: GestureDetector(
  //                           onTap: () async {
  //                             try {
  //                               var prediction = await PlacesAutocomplete.show(
  //                                 context: screen.context,
  //                                 apiKey: kGoogleApiKey,
  //                                 mode: Mode.overlay,
  //                                 overlayBorderRadius: BorderRadius.circular(8),
  //                                 components: [
  //                                   Component(Component.country, 'ke')
  //                                 ],
  //                                 strictbounds: false,
  //                                 types: [],
  //                                 proxyBaseUrl: kIsWeb ? kProxyBaseUrl : null,
  //                               );

  //                               if (prediction != null &&
  //                                   prediction.placeId != null) {
  //                                 final place = await GoogleMapsPlaces(
  //                                   apiKey: kGoogleApiKey,
  //                                   apiHeaders: await const GoogleApiHeaders()
  //                                       .getHeaders(),
  //                                   baseUrl: kIsWeb ? kProxyBaseUrl : null,
  //                                 ).getDetailsByPlaceId(prediction.placeId!);

  //                                 if (place.hasNoResults) {
  //                                   throw 'Something went wrong. Try again';
  //                                 }

  //                                 controller.data.update((val) {
  //                                   val!['area'] = prediction.description;
  //                                   val['latitude'] =
  //                                       place.result.geometry!.location.lat;
  //                                   val['longitude'] =
  //                                       place.result.geometry!.location.lng;
  //                                 });

  //                                 controller.updateLocation();
  //                               }
  //                             } catch (e) {
  //                               Util.toast(e);
  //                             }
  //                           },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               color: Colors.grey.shade200,
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             padding: const EdgeInsets.symmetric(
  //                               horizontal: 16,
  //                               vertical: 12,
  //                             ),
  //                             child: Row(
  //                               children: [
  //                                 const Icon(Icons.search),
  //                                 const SizedBox(
  //                                   width: 8,
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(controller.data.value['area'] ??
  //                                       'Search place'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 8,
  //                       ),
  //                       IconButton(
  //                         onPressed: () async {
  //                           await controller.updateCurrentLocation();

  //                           controller.updateLocation();
  //                         },
  //                         icon: Obx(
  //                           () => controller.isRequestingMyLocation.isTrue
  //                               ? CircularProgressIndicator(
  //                                   color: controller.color,
  //                                 )
  //                               : const Icon(
  //                                   Icons.my_location_outlined,
  //                                 ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Obx(
  //                     () => Column(
  //                       crossAxisAlignment: CrossAxisAlignment.stretch,
  //                       children: [
  //                         if (controller.data.value['area'] != null)
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                         if (controller.data.value['area'] != null) ...[
  //                           const SizedBox(
  //                             height: 16,
  //                           ),
  //                           MapWidget(
  //                             onMapCreated: (updateMap) {
  //                               controller.updateMap = updateMap;

  //                               controller.updateLocation();
  //                             },
  //                           ),
  //                         ],
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 32,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             if (controller.data.value['product'] == null &&
  //                                 withProduct == 'yes' &&
  //                                 type == 'disposal') {
  //                               Util.toast('Search subscription plan');
  //                             } else if (controller.data.value['area'] ==
  //                                 null) {
  //                               Util.toast('Search place');
  //                             } else {
  //                               controller.bookingState.value =
  //                                   BookingState.kWaste;
  //                             }
  //                           },
  //                           style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(controller.color),
  //                           ),
  //                           child: const Text('Next step'),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );