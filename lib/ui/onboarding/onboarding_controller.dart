import 'dart:async';

import 'package:baustaka/config/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  int currentPage = 0;

  final pages = <OnboardingPage>[
    OnboardingPage(
      Images.kImgMission,
      'Join us in the mission to make our planet cleaner through efficient waste management',
    ),
    OnboardingPage(
      Images.kImgRecycle,
      'Join the Green Movement! Be part of a community that cares about the environment',
    ),
    OnboardingPage(Images.kImgTruck,
        'Hassle-free waste collection and disposal with our efficient services'),
  ];

  final PageController pageController = PageController();

  @override
  void onReady() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < pages.length - 1) {
        currentPage++;

        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });

    super.onReady();
  }
}

class OnboardingPage {
  final String image, description;

  OnboardingPage(this.image, this.description);
}
