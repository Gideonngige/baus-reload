import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isFetching = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );

    super.onInit();
  }
}
