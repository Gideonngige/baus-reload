import 'package:baustaka/api/promo_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/promo.dart';
import 'package:get/get.dart';

class PromoController extends GetxController {
  var isFetching = false.obs;
  var isUpdating = false.obs;

  Rx<Promo?> promo = Rx(null);

  final _promoApi = Get.put(PromoApi());

  final String promoId;

  PromoController({required this.promoId});

  @override
  void onInit() async {
    super.onInit();

    fetch();
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      promo.value =
          (await _promoApi.retrieve({'promoId': promoId})).data!.promo;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  updateStatus(status) async {
    if (isUpdating.isTrue) return;

    isUpdating.value = true;

    try {
      promo.value =
          (await _promoApi.update(promoId, {'status': status})).data!.promo;
    } catch (e) {
      Util.toast(e);
    }

    isUpdating.value = false;
  }
}
