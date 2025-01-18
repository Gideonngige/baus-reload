import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailsWidget
    extends ResponsiveWidget<HomeWasteManagerController> {
  BookingDetailsWidget({super.key});

  @override
  String get tag => 'home';

  @override
  HomeWasteManagerController get controller => Get.put(
        HomeWasteManagerController(),
        tag: tag,
        permanent: true,
      );

  @override
  Widget? desktop() => Container(
        color: Theme.of(screen.context).primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              key: const Key('booking_details'),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Pick up waste around',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          var station = await Get.toNamed(Routes.kStations);

                          if (station != null) {
                            controller.updatePicker(
                                {'station': (station as Station).id});
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
                                  controller.picker.value?.station?.title ??
                                      'Search transfer station'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text(''),
                          onPressed: () => controller.bookingState.value =
                              BookingState.kNotStarted,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Obx(
                              () => controller.isRequesting.isTrue ||
                                      controller.isUpdating.isTrue
                                  ? const CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : const Text('Next step'),
                            ),
                            onPressed: () async {
                              if (controller.picker.value?.station == null) {
                                Util.toast('Search transfer station');
                              } else if (controller.isRequesting.isTrue ||
                                  controller.isUpdating.isTrue) {
                                Util.toast('Please wait');
                              } else {
                                await controller.fetchPost();
                              }
                            },
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
            ),
          ),
        ),
      );
}
