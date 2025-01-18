import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashWidget extends GetResponsiveView<SplashController> {
  SplashWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  SplashController get controller => Get.put(
        SplashController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.kImgBackgroundMid),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Image.asset(Images.kImgBannerLogo),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                  ),
                  child: Text(
                    kAppTag,
                    style:
                        Theme.of(screen.context).textTheme.titleLarge?.copyWith(
                              color: Palette.primary,
                            ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Center(
                  child: Obx(
                    () => Visibility(
                      visible: controller.isFetching.isTrue ? true : true,
                      child: Image.asset(Images.kImgLoading),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
}
