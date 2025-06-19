import 'package:baustaka/ui/_/progress_rounded_containers.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:baustaka/ui/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingProductWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  BookingProductWidget({
    super.key,
    required this.type,
    required this.withProduct,
  });

  @override
  String get tag => 'booking $type $withProduct';

  @override
  BookingController get controller => Get.put(
        BookingController(
          type: type,
          withProduct: withProduct,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() {
    final productsController = Get.put(ProductsController(), tag: 'products_controller');
    
    // Ensure products are fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productsController.products.isEmpty) {
        productsController.fetch(true);
      }
    });
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        key: const Key('booking_product'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circularContainer(controller.color),
                  dashedContainer(Colors.grey.withValues(alpha: 0.4)),
                  borderContainer(),
                  dashedContainer(Colors.grey.withValues(alpha: 0.4)),
                  borderContainer(),
                  dashedContainer(Colors.grey.withValues(alpha: 0.4)),
                  borderContainer(),
                ],
              ),
            ),
            const TitleText(
              text: 'Select subscription plan',
              color: Colors.black,
              fontSize: 17,
            ),
            const SizedBox(height: 16),
            Obx(
              () => productsController.products.isNotEmpty
                  ? Column(
                      children: productsController.products.map((product) {
                        return GestureDetector(
                          onTap: () {
                            // Set the selected product in booking data
                            controller.data.update((val) {
                              val!['product'] = product;
                            });
                            // Move to next step (details)
                            controller.bookingState.value = BookingState.kDetails;
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: controller.data.value['product'] == product
                                    ? controller.color
                                    : Colors.grey.shade200,
                                width: controller.data.value['product'] == product ? 2 : 1,
                              ),
                              color: controller.data.value['product'] == product
                                  ? controller.color.withValues(alpha: 0.1)
                                  : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: Text(
                                    'Name',
                                    style: Theme.of(screen.context).textTheme.bodySmall,
                                  ),
                                  subtitle: Text(
                                    '${product.name}',
                                    style: Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  trailing: controller.data.value['product'] == product
                                      ? Icon(Icons.check_circle, color: controller.color)
                                      : null,
                                ),
                                ListTile(
                                  title: Text(
                                    'Weekly pickups',
                                    style: Theme.of(screen.context).textTheme.bodySmall,
                                  ),
                                  subtitle: Text(
                                    '${product.weeklyPickups}x weekly (${product.weeklyPickups! * 4}x monthly)',
                                    style: Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Price',
                                    style: Theme.of(screen.context).textTheme.bodySmall,
                                  ),
                                  subtitle: Text(
                                    'Ksh ${product.price} monthly',
                                    style: Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                if (product.discount! > 0)
                                  ListTile(
                                    title: Text(
                                      'Discount',
                                      style: Theme.of(screen.context).textTheme.bodySmall,
                                    ),
                                    subtitle: Text(
                                      'Ksh ${product.discount} monthly',
                                      style: Theme.of(screen.context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: productsController.isFetching.isTrue
                            ? const CircularProgressIndicator()
                            : const Text('No subscription plans available'),
                      ),
                    ),
            ),
            const SizedBox(height: 32),
            if (controller.data.value['product'] != null)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.bookingState.value = BookingState.kDetails;
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(controller.color),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 