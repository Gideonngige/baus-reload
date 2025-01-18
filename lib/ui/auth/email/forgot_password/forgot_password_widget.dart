import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/email/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordWidget extends GetResponsiveView<ForgotPasswordController> {
  ForgotPasswordWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  ForgotPasswordController get controller => Get.put(
        ForgotPasswordController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Forgot your password?'),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text('We will send a link to reset your password'),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  decoration: kInputDecoration.copyWith(
                    hintText: 'john.doe@gmail.com',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  onChanged: (value) => controller.email = value,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
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
                        : const Text('Send link'),
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
