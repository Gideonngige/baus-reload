import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentPage = RxInt(2);

  PageController pageController = PageController(
    initialPage: 2,
  );

  @override
  void onInit() {
    ever(currentPage, (int value) => pageController.jumpToPage(value));

    super.onInit();
  }
}
