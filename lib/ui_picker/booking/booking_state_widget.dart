import 'package:baustaka/config/palette.dart';
import 'package:baustaka/ui/_/dashed_line_widget.dart';
import 'package:baustaka/ui/_/progress_tab_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingStateWidget extends ResponsiveWidget<HomeWasteManagerController> {
  BookingStateWidget({super.key});

  @override
  String get tag => 'home';

  @override
  HomeWasteManagerController get controller => Get.put(
        HomeWasteManagerController(),
        tag: tag,
        permanent: true,
      );

  @override
  Widget? desktop() => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(screen.context).primaryColor,
              Theme.of(screen.context).primaryColor,
            ],
          )),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: DashedLineWidget(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const ProgressTabWidget(
                    enabled: true,
                    position: 1,
                    color: Palette.primary,
                  ),
                  Expanded(
                    child: DashedLineWidget(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  ProgressTabWidget(
                    enabled:
                        controller.bookingState.value == BookingState.kPayment,
                    position: 2,
                    color: Palette.primary,
                  ),
                  Expanded(
                    child: DashedLineWidget(
                      color: Colors.white.withOpacity(0.3),
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
