import 'package:baustaka/ui/_/item/product_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsWidget extends ResponsiveWidget<ProductsController> {
  ProductsWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'products_controller';

  @override
  ProductsController get controller => Get.put(ProductsController(), tag: tag);

  @override
  Widget? tablet() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select subscription plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => controller.showSearch.toggle(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.q = '';
          controller.fetch(true);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.fetch(false);
            }
            return false;
          },
          child: Column(
            children: [
              Obx(() => controller.showSearch.isTrue
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {
                                    controller.q = value;
                                    controller.fetch(true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()),
              Obx(
                () => Expanded(
                  child: controller.products.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];

                            return ProductItemWidget(
                              product: product,
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48),
                                child: controller.isFetching.isTrue
                                    ? const CircularProgressIndicator()
                                    : const Text('No subscription plans'),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
