import 'package:baustaka/model/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;
  final bool showRegistered;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.showRegistered = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                'Name',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                '${product.name}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: ElevatedButton(
                onPressed: () => Get.back(result: product),
                child: const Text('Select'),
              ),
            ),
            ListTile(
              title: Text(
                'Weekly pickups',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                '${product.weeklyPickups}x weekly (${product.weeklyPickups! * 4}x monthly)',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              title: Text(
                'Price',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                'Ksh ${product.price} monthly',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (product.discount! > 0)
              ListTile(
                title: Text(
                  'Discount',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text(
                  'Ksh ${product.discount} monthly',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
      );
}
