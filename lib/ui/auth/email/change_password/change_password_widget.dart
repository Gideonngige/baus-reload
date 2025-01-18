import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/email/change_password/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordWidget extends GetResponsiveView<ChangePasswordController> {
  ChangePasswordWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  ChangePasswordController get controller => Get.put(
        ChangePasswordController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Change your password'),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text('Update your password'),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: 'New password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureText.isFalse
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.obscureText.toggle();
                        },
                      ),
                    ),
                    onChanged: (value) => controller.password = value,
                    obscureText: controller.obscureText.value,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: 'Confirm new password',
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.confirmObscureText.isFalse
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.confirmObscureText.toggle();
                        },
                      ),
                    ),
                    onChanged: (value) => controller.confirmPassword = value,
                    obscureText: controller.confirmObscureText.value,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.reset();
                  },
                  child: Obx(
                    () => controller.isResettingPassword.isTrue
                        ? const ProgressWidget()
                        : const Text('Update'),
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
