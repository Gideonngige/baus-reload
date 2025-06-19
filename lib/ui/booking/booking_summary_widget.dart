import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BookingSummaryWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingSummaryWidget({
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

  Future<String?> fetchPhoneFromServer() async {
    try {
      final userApi = UserApi();
      final response = await userApi.me();
      final user = response.data?.user; // parse from BaseResponse
      return user?.phoneNumber;
    } catch (e) {
      // If an error occurs, log or show toast, then return null
      print('fetchPhoneFromServer error: $e');
      return null;
    }
  }

  Widget _summaryContainer({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.grey.withOpacity(.4),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: title,
            color: Colors.black,
            fontSize: 15,
          ),
          const Gap(5),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 19),
          )
        ],
      ),
    );
  }

  @override
  Widget? tablet() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: SingleChildScrollView(
          key: const Key('booking_summary'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    markedContainer(controller.color),
                    dashedContainer(controller.color),
                    markedContainer(controller.color),
                    dashedContainer(controller.color),
                    markedContainer(controller.color),
                    dashedContainer(controller.color),
                    markedContainer(controller.color),
                  ],
                ),
              ),
              TitleText(
                text: 'Summary',
                color: controller.color,
                fontSize: 25,
              ),
              if (withProduct == 'yes' && type == 'disposal')
                ListTile(
                  title: Text(
                    'Subscription plan',
                    style: Theme.of(screen.context).textTheme.bodySmall,
                  ),
                  subtitle: Text(
                    '${(controller.data.value['product'] as Product).name} · ${(controller.data.value['product'] as Product).weeklyPickups}x weekly',
                    style:
                        Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                ),
              _summaryContainer(
                title: 'Booking for',
                value: controller.data.value['client'].toString().capitalize!,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.grey.withOpacity(.4),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          text: 'Pickup using',
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        const Gap(5),
                        Text(
                          controller.data.value['mode'].toString().capitalize!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 19),
                        )
                      ],
                    ),
                    if (controller.data.value['client'] == 'residential')
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.color,
                        ),
                        child: Text(
                          'Ksh ${controller.data.value['price']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _summaryContainer(
                title: 'Pickup Address',
                value: controller.data.value['area'],
              ),
              if (withProduct != 'yes' || type != 'disposal')
                _summaryContainer(
                  title: 'How Often',
                  value:
                      controller.data.value['frequency'].toString().capitalize!,
                ),
              // ListTile(
              //   title: Text(
              //     'Drop off (transfer station)',
              //     style: Theme.of(screen.context).textTheme.bodySmall,
              //   ),
              //   // subtitle: Text(
              //   //   controller.station.value!.title!,
              //   //   style: Theme.of(screen.context)
              //   //       .textTheme
              //   //       .bodyLarge
              //   //       ?.copyWith(
              //   //         fontWeight: FontWeight.bold,
              //   //       ),
              //   // ),
              //   contentPadding: const EdgeInsets.all(0),
              //   onTap: () => Util.directions(
              //       controller.station.value!.point!.coordinates!),
              // ),
              _summaryContainer(
                title: 'Type of Waste',
                value: (controller.data.value['categories'] as List<String>)
                    .map((e) => e.capitalize)
                    .join(', '),
              ),
              _summaryContainer(
                title:
                    'No. of ${controller.data.value['type'] == 'sale' ? 'kilos' : 'waste bags'}',
                value: controller.data.value['total'].toString().capitalize!,
              ),
              // ListTile(
              //   title: Text(
              //     'How the waste is sorted',
              //     style: Theme.of(screen.context).textTheme.bodySmall,
              //   ),
              //   subtitle: Text(
              //     (controller.data.value['groups'] as List<String>)
              //         .map((e) => e.capitalize)
              //         .join(', '),
              //     style: Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
              //           fontWeight: FontWeight.bold,
              //         ),
              //   ),
              //   contentPadding: const EdgeInsets.all(0),
              // ),
              FutureBuilder<String?>(
                future: fetchPhoneFromServer(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final phone = snapshot.data ?? 'N/A';
                    return _summaryContainer(
                      title: 'Mpesa Number',
                      value: phone,
                    );
                  }
                },
              ),

              // if (controller.data.value['client'] != 'residential')
              //   Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey.shade50,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: ListTile(
              //       title: Text(
              //         'Please note!',
              //         style: Theme.of(screen.context).textTheme.bodySmall,
              //       ),
              //       subtitle: Text(
              //         'We will reach out to you with a ${controller.data.value['client']} quotation',
              //         style: Theme.of(screen.context)
              //             .textTheme
              //             .bodyLarge
              //             ?.copyWith(
              //               fontWeight: FontWeight.bold,
              //             ),
              //       ),
              //       contentPadding: const EdgeInsets.all(0),
              //     ),
              //   ),
              // const SizedBox(
              //   height: 32,
              // ),
              const Gap(30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        controller.bookingState.value = BookingState.kPayment,
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: controller.color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: controller.color,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async => await controller.request(),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(controller.color),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Obx(
                        () => controller.isRequesting.isTrue
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: controller.color,
                              )
                            : Text(withProduct == 'yes' && type == 'disposal'
                                ? 'Subscribe'
                                : 'Make Request'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
}
