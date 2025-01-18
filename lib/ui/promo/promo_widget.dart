import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/promo/promo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PromoWidget extends ResponsiveWidget<PromoController> {
  final String promoId;

  PromoWidget({super.key, required this.promoId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'promo $promoId';

  @override
  PromoController get controller =>
      Get.put(PromoController(promoId: promoId), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Promotion'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var promo = controller.promo.value;

              if (promo == null) {
                return ListView();
              } else {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(16),
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
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'OFF',
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
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
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '#${promo.code!.toUpperCase()}',
                        style: Theme.of(screen.context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Text('Up to Ksh ${promo.max}'),
                      ),
                      Text(
                        'Expires on ${Util.formatDate(promo.dateEnd)}',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: promo.code ?? ''));

                          Util.toast('${promo.code} copied');
                        },
                        child: const Text(
                          'Copy',
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
}
