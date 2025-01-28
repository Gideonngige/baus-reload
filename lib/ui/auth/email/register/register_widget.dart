import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/policy_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/email/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterWidget extends GetResponsiveView<RegisterController> {
  RegisterWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  RegisterController get controller => Get.put(
        RegisterController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: KeyboardWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 360 / 320,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Images.kImgTopBanner),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      heightFactor: 2,
                      child: SizedBox(
                        width: 176,
                        child: Image.asset(Images.kImgBannerLogo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    'Create an account',
                    style: Theme.of(screen.context).appBarTheme.titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: 'john.doe@gmail.com',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    onChanged: (value) => controller.email = value,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: '123-456-7890',
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    onChanged: (value) => controller.phoneNumber = value,
                    keyboardType: TextInputType.phone,
                    textAlignVertical: TextAlignVertical.center,
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
                        hintText: 'Password',
                        labelText: 'Password',
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
                      onChanged: (value) => controller.confirmPassword = value,
                      obscureText: controller.confirmObscureText.value,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Confirm password',
                        labelText: 'Confirm password',
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
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ListTile(
                  leading: Obx(
                    () => Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (value) => controller.isAgreed.value = value!,
                    ),
                  ),
                  title: const PolicyWidget(
                    leading: TextSpan(
                      text: 'Accept ',
                      style: TextStyle(
                        color: Palette.textSecondary,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  onTap: () => controller.isAgreed.toggle(),
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
                      await controller.register();
                    },
                    child: Obx(
                      () => controller.isRegistering.isTrue
                          ? const ProgressWidget()
                          : const Text('Register'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      );
}
