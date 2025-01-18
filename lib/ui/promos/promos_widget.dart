import 'package:baustaka/ui/_/item/promo_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/promos/promos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromosWidget extends ResponsiveWidget<PromosController> {
  PromosWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'promotions';

  @override
  PromosController get controller => Get.put(PromosController(), tag: tag);

  @override
  Widget? tablet() => Obx(() => Scaffold(
        appBar: AppBar(
          title: const Text('Promotions'),
          actions: const [],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch(true);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) controller.fetch(false);
              return false;
            },
            child: controller.promos.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.promos.length,
                    itemBuilder: (context, index) =>
                        PromoItemWidget(promo: controller.promos[index]),
                  )
                : ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: controller.isFetching.isTrue
                              ? const CircularProgressIndicator()
                              : const Text('No promotions'),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ));
}
