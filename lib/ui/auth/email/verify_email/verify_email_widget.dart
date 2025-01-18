import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'verify_email_controller.dart';

class VerifyEmailWidget extends GetResponsiveView<VerifyEmailController> {
  VerifyEmailWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  VerifyEmailController get controller => Get.put(
        VerifyEmailController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Verify your email'),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text(
                  'We will send a link to verify your email',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.verify();
                  },
                  child: Obx(
                    () => controller.isVerifying.isTrue
                        ? const ProgressWidget()
                        : const Text('Verify'),
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      );
}
