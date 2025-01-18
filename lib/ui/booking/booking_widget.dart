import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:baustaka/ui/booking/booking_details_widget.dart';
import 'package:baustaka/ui/booking/booking_payment_widget.dart';
import 'package:baustaka/ui/booking/booking_summary_widget.dart';
import 'package:baustaka/ui/booking/booking_waste_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingWidget({
    super.key,
    required this.type,
    required this.withProduct,
  });

  @override
  String get tag => 'booking $type $withProduct';

  @override
  bool get shouldAdjust => true;

  @override
  BookingController get controller => Get.put(
        BookingController(
          type: type,
          withProduct: withProduct,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Obx(
        () => PopScope(
          onPopInvokedWithResult: (popped, result) async {
            switch (controller.bookingState.value) {
              case BookingState.kDetails:
                await cancel();
                break;
              case BookingState.kWaste:
                controller.bookingState.value = BookingState.kDetails;
                break;
              case BookingState.kPayment:
                controller.bookingState.value = BookingState.kWaste;
                break;
              case BookingState.kSummary:
                controller.bookingState.value = BookingState.kPayment;
                break;
              default:
                return;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                color: controller.color,
                onPressed: () async {
                  Get.back();
                },
              ),
              title: TitleText(
                text: _title(),
                color: controller.color,
                fontSize: 22,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                // BookingStateWidget(
                //   type: type,
                //   withProduct: withProduct,
                // ),
                if (controller.bookingState.value == BookingState.kDetails)
                  Expanded(
                    child: BookingDetailsWidget(
                      type: type,
                      withProduct: withProduct,
                    ),
                  ),
                if (controller.bookingState.value == BookingState.kWaste)
                  Expanded(
                    child: BookingWasteWidget(
                      type: type,
                      withProduct: withProduct,
                    ),
                  ),
                if (controller.bookingState.value == BookingState.kPayment)
                  Expanded(
                    child: BookingPaymentWidget(
                      type: type,
                      withProduct: withProduct,
                    ),
                  ),
                if (controller.bookingState.value == BookingState.kSummary)
                  Expanded(
                    child: BookingSummaryWidget(
                      type: type,
                      withProduct: withProduct,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  String _title() {
    switch (type) {
      case 'sale':
        return 'Sell plastic waste';
      case 'donation':
        return 'Donate plastic waste';
      default:
        return withProduct == 'yes'
            ? 'Subscribe to a monthly plan'
            : 'Dispose waste';
    }
  }

  cancel() async => await Get.dialog(
        DialogWidget(
          title: 'Cancel Booking',
          content: 'Do you want to cancel booking?',
          onConfirm: () => Get.back(),
          confirmText: 'Yes',
          color: controller.color,
        ),
      );
}
