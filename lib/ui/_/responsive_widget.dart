import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ResponsiveWidget<T> extends GetResponsiveView<T> {
  ResponsiveWidget({super.key});

  bool get shouldAdjust => false;

  Color get background => Colors.grey.shade50;

  @override
  Widget build(BuildContext context) {
    init();

    return super.build(context);
  }

  init() {}

  @override
  Widget? desktop() => shouldAdjust
      ? Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: background,
              ),
            ),
            Expanded(
              flex: 2,
              child: tablet() ?? phone() ?? Container(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: background,
              ),
            ),
          ],
        )
      : tablet() ?? phone();
}
