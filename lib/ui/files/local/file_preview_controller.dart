import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilePreviewController extends GetxController {
  final RxList<File> files;
  final int initialPosition;

  late PageController pageController;

  var page = 0.obs;

  FilePreviewController({
    required this.files,
    required this.initialPosition,
  });

  @override
  void onInit() {
    pageController = PageController(
      initialPage: initialPosition,
    );

    page.value = initialPosition;

    super.onInit();
  }
}
