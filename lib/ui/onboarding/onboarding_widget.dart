import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keep_alive_widget.dart';
import 'package:baustaka/ui/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingWidget extends GetResponsiveView<OnboardingController> {
  OnboardingWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  OnboardingController get controller => Get.put(
        OnboardingController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.pages.length, // Add itemCount
                  onPageChanged: (index) {
                    if (index < controller.pages.length) {
                      controller.currentPage = index;
                    }
                  },
                  itemBuilder: (context, index) => KeepAliveWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.pages[index].image,
                                width: 240,
                              ),
                              const SizedBox(
                                height: 64,
                              ),
                              Text(
                                controller.pages[index].description,
                                textAlign: TextAlign.center,
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                              3,
                              (i) => Indicator(
                                isActive: i == index,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Image.asset(
                Images.kImgBackgroundBottom,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async =>
              await Get.offAndToNamed(Routes.kLoginWithEmail),
          label: const Text('Skip'),
          icon: const Icon(
            Icons.arrow_forward,
          ),
        ),
      );
}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 32.0 : 8.0,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Palette.primary : Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
