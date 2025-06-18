import 'package:baustaka/config/asset.dart';
import 'package:baustaka/config/category.dart';
import 'package:baustaka/config/group.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BookingWasteWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingWasteWidget({
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

  setSelectedRadioTile(val) {
    // This method can be removed as group selection is handled directly in the onTap
  }

  @override
  Widget? tablet() => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          key: const Key('booking_waste'),
          child: Obx(
            () => Column(
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
                      circularContainer(controller.color),
                      dashedContainer(Colors.grey.withOpacity(.4)),
                      borderContainer(),
                      dashedContainer(Colors.grey.withOpacity(.4)),
                      borderContainer(),
                    ],
                  ),
                ),
                const TitleText(
                  text: 'Type of waste',
                  color: Colors.black,
                  fontSize: 17,
                ),
                const SizedBox(
                  height: 16,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...kCategorys(controller.data.value['type']).map(
                      (e) => GestureDetector(
                        onTap: () => controller.data.update((val) {
                          List<String> categories =
                              val!['categories'] as List<String>;

                          if (categories.contains(e)) {
                            categories.remove(e);
                          } else {
                            categories.add(e);
                          }

                          val['categories'] = categories;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: (controller.data.value['categories']
                                        as List<String>)
                                    .contains(e)
                                ? kAppTheme.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              if (controller.data.value['type'] != 'disposal')
                                SizedBox(
                                  height: 64,
                                  child: Image.asset(
                                    Assets().image(e),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              if (controller.data.value['type'] != 'disposal')
                                const SizedBox(
                                  height: 8,
                                ),
                              Text(
                                e.capitalize!,
                                style: TextStyle(
                                  color: (controller.data.value['categories']
                                              as List<String>)
                                          .contains(e)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    ...kGroups(controller.data.value['type']).map(
                      (e) => Expanded(
                        child: GestureDetector(
                          onTap: () => controller.data.update((val) {
                            List<String> groups =
                                val!['groups'] as List<String>;

                            if (groups.contains(e)) {
                              groups.remove(e);
                            } else {
                              groups.clear();
                              groups.add(e);
                            }

                            val['groups'] = groups;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              border: Border(
                                top: BorderSide(
                                  width: 3.0,
                                  color: (controller.data.value['groups']
                                              as List<String>)
                                          .contains(e)
                                      ? controller.color
                                      : Colors.grey.shade200,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                e.capitalize!,
                                style: TextStyle(
                                  color: (controller.data.value['groups']
                                              as List<String>)
                                          .contains(e)
                                      ? controller.color
                                      : Colors.black,
                                ),
                              ),
                              trailing: Radio(
                                fillColor:
                                    WidgetStateProperty.all(controller.color),
                                value: e,
                                groupValue: (controller.data.value['groups'] as List<String>).isNotEmpty 
                                    ? (controller.data.value['groups'] as List<String>)[0] 
                                    : null,
                                onChanged: (val) {
                                  controller.data.update((data) {
                                    List<String> groups = data!['groups'] as List<String>;
                                    groups.clear();
                                    groups.add(val!);
                                    data['groups'] = groups;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'No. of ${controller.data.value['type'] == 'sale' ? 'kilos' : 'waste bags'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kAppTheme.hintColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kAppTheme.hintColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    try {
                      var val = controller.data.value;
                      try {
                        val['total'] = int.tryParse(value);

                        if (val['total'] == 0) {
                          throw 'Value cannot be 0';
                        }
                      } catch (e) {
                        val['total'] = 1;
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: controller.total,
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          controller.bookingState.value = BookingState.kDetails,
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
                          if ((controller.data.value['categories'] as List)
                              .isEmpty) {
                            Util.toast('Select type of waste');
                          } else if ((controller.data.value['groups'] as List)
                              .isEmpty) {
                            Util.toast('How is the waste sorted?');
                          } else if (controller.data.value['total'] == null) {
                            Util.toast('No. of waste bags');
                          } else {
                            controller.bookingState.value =
                                BookingState.kPayment;
                            await controller.price();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(controller.color),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white)),
                        child: controller.isPricing.isTrue
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: controller.color,
                              )
                            : const Text(
                                'Next step',
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
        ),
      );
}
