import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingStateWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingStateWidget({
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circularContainer(kAppTheme.primaryColor),
                dashedContainer(Colors.grey.withOpacity(.4)),
                borderContainer(),
                dashedContainer(Colors.grey.withOpacity(.4)),
                borderContainer(),
                dashedContainer(Colors.grey.withOpacity(.4)),
                borderContainer(),
              ],
            ),
          ],
        ),
      );
}
