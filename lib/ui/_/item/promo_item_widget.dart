import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/promo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoItemWidget extends StatelessWidget {
  final Promo promo;

  const PromoItemWidget({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Get.toNamed('${Routes.kPromotion}${promo.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${promo.discount}%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'OFF',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      promo.points! > 0
                          ? Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${promo.points} pts',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                    ],
                  )),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${promo.code!.toUpperCase()}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text('Up to Ksh ${promo.max}'),
                  ),
                  Text(
                    'Expires on ${Util.formatDate(promo.dateEnd)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
