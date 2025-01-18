import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/phone/verify_phone/verify_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyPhoneWidget extends GetResponsiveView<VerifyPhoneController> {
  final String phoneNumber;
  final String? action;

  VerifyPhoneWidget({
    super.key,
    required this.phoneNumber,
    this.action,
  });

  @override
  String get tag => Util.tag();

  @override
  VerifyPhoneController get controller => Get.put(
        VerifyPhoneController(
          phoneNumber: '+$phoneNumber',
          action: action,
        ),
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
                    'Enter code sent to your phone',
                    style: Theme.of(screen.context).appBarTheme.titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'We sent it to '),
                        TextSpan(
                          text: '+$phoneNumber',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(screen.context).textTheme.titleSmall,
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
                    onChanged: (value) => controller.smsCode = value,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: kInputDecoration.copyWith(
                      hintText: '012345',
                      prefixIcon: const Icon(Icons.lock_open),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: GestureDetector(
                    onTap: () async => await controller.verify(),
                    child: Obx(
                      () => Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Didn\'t receive the OTP? ',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Palette.textSecondary,
                                  ),
                            ),
                            TextSpan(
                              text: 'Resend OTP',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(screen.context)
                                          .primaryColor),
                            ),
                            if (controller.seconds.value > 0)
                              TextSpan(
                                text: ' in ${controller.seconds.value} seconds',
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Palette.textSecondary,
                                    ),
                              )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                      await controller.signIn();
                    },
                    child: Obx(
                      () => controller.isVerifying.isTrue ||
                              controller.isSigningIn.isTrue
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
        ),
      );
}
