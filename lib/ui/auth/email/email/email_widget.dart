import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/policy_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/email/email/email_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailWidget extends GetResponsiveView<EmailController> {
  EmailWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  EmailController get controller => Get.put(
        EmailController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
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
                    'Log in',
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
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async =>
                            await Get.toNamed(Routes.kForgotPassword),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Palette.textPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          var result = await Get.toNamed(Routes.kRegister);

                          if (result == true) Get.back(result: true);
                        },
                        child: const Text(
                          'Create an account',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.signIn();
                    },
                    child: Obx(
                      () => controller.isSigningIn.isTrue
                          ? const ProgressWidget()
                          : const Text('Log in'),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 16, left: 16),
                        child: const Text(
                          'or Sign in with',
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      FloatingActionButton(
                        heroTag: 'phone',
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Palette.primary,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Palette.primary,
                        elevation: 0,
                        onPressed: () async {
                          var result =
                              await Get.toNamed(Routes.kLoginWithPhone);

                          if (result == true) {
                            Session.login(splash: true);
                          }
                        },
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'google',
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        onPressed: () async {
                          await controller.signInWithGoogle();
                        },
                        child: Obx(
                          () => controller.isSigningInWithGoogle.isTrue
                              ? const ProgressWidget(
                                  color: Palette.primary,
                                )
                              : Image.asset(
                                  Images.kLogoGoogle,
                                  height: 32,
                                  width: 32,
                                ),
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'apple',
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.black,
                        elevation: 0,
                        onPressed: () async {
                          await controller.signInWithApple();
                        },
                        child: Obx(
                          () => controller.isSigningInWithApple.isTrue
                              ? const ProgressWidget()
                              : Image.asset(
                                  Images.kLogoApple,
                                  color: Colors.white,
                                  height: 32,
                                  width: 32,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () async => await Util.url(kPolicyUrl),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: const PolicyWidget(),
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
              ],
            ),
          ),
        ),
      );
}
