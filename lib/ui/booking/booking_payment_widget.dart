import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/config/frequency.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BookingPaymentWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingPaymentWidget({
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
  Widget? tablet() => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          key: const Key('booking_payment'),
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
                    circularContainer(controller.color),
                    dashedContainer(Colors.grey.withOpacity(.4)),
                    borderContainer(),
                  ],
                ),
              ),
              const Text(
                'Pick up using',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(
                () => Wrap(
                  runSpacing: 8,
                  children: [
                    ...controller.prices.map(
                      (e) => GestureDetector(
                        onTap: () => controller.data.update((val) {
                          val!['mode'] = e.mode;
                          val['price'] = e.cost;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10,
                          ),
                          margin:
                              const EdgeInsets.only(right: 20.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: controller.color, width: 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                e.mode!.capitalize!,
                                style: TextStyle(
                                  color: e.mode == controller.data.value['mode']
                                      ? Colors.green
                                      : Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              if (controller.data.value['client'] ==
                                  'residential')
                                Text(
                                  'Ksh ${e.cost}',
                                  style: TextStyle(
                                    color:
                                        e.mode == controller.data.value['mode']
                                            ? Colors.green
                                            : Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              if (withProduct != 'yes' || type != 'disposal') ...[
                const Text(
                  'How often',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Wrap(
                  runSpacing: 1,
                  children: [
                    ...kFrequencys.map(
                      (e) => GestureDetector(
                        onTap: () => controller.data.update((val) {
                          val!['frequency'] = e;
                        }),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          margin:
                              const EdgeInsets.only(right: 20.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            color: e == controller.data.value['frequency']
                                ? controller.color
                                : Colors.white,
                            border: Border.all(
                              color: controller.color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              e.capitalize!,
                              style: TextStyle(
                                color: e == controller.data.value['frequency']
                                    ? Colors.white
                                    : controller.color,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
              // Row(
              //   children: [
              //     const TitleText(
              //       text: 'PAYMENT:',
              //       color: Colors.black,
              //       fontSize: 20,
              //     ),
              //     const Gap(10),
              //     Column(
              //       children: [
              //         Image.asset('assets/images/mpesa_logo.png', width: 50),
              //         Text(
              //           controller.phoneNumber.text,
              //           style: TextStyle(
              //             color: kAppTheme.hintColor,
              //             fontSize: 14,
              //           ),
              //         ),
              //       ],
              //     ),
              //     Expanded(child: Container()),
              //     GestureDetector(
              //       onTap: () async => await Get.toNamed(
              //         Routes.kChangePhoneNumber,
              //         parameters: {
              //           'type': type,
              //           'withProduct': withProduct,
              //         },
              //       ),
              //       child: Row(
              //         children: [
              //           Text(
              //             'Change',
              //             style:
              //                 TextStyle(color: controller.color, fontSize: 16),
              //           ),
              //           const Icon(Icons.chevron_right)
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // const Gap(50),
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        controller.bookingState.value = BookingState.kWaste,
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
                      onPressed: () async {
                        Future<String?> fetchPhoneFromServer() async {
                          try {
                            final userApi = UserApi();
                            final response = await userApi.me();
                            final user =
                                response.data?.user; // parse from BaseResponse
                            return user?.phoneNumber;
                          } catch (e) {
                            // If an error occurs, log or show toast, then return null
                            print('fetchPhoneFromServer error: $e');
                            return null;
                          }
                        }

                        // 1) Validate other fields first
                        if (controller.data.value['mode'] == null) {
                          Util.toast('Pick up using?');
                          return;
                        } else if (controller.data.value['date'] == null) {
                          Util.toast('Schedule pick up');
                          return;
                        } else if (controller.data.value['frequency'] == null) {
                          Util.toast('How often should this be repeated?');
                          return;
                        }

                        // 2) Fetch phone from server
                        final phone = await fetchPhoneFromServer();
                        if (phone == null || phone.isEmpty) {
                          // phone not found => prompt user to update
                          Util.toast(
                              'No phone number found on server. Please update your profile.');
                          Get.toNamed(Routes
                              .kProfile); // or go to /profile with some param
                          return;
                        }

                        // 3) If phone found, set in controller data
                        controller.data
                            .update((val) => val!['phoneNumber'] = phone);

                        // 4) Now proceed to summary or final step
                        controller.bookingState.value = BookingState.kSummary;
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(controller.color),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      child: const Text(
                        'Next Step',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
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
