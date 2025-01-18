import 'package:baustaka/api/promo_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/promo.dart';
import 'package:baustaka/model/promo_page.dart';
import 'package:get/get.dart';

class PromosController extends GetxController {
  var isFetching = false.obs;

  final _promoApi = Get.put(PromoApi());

  RxList<Promo> promos = RxList.empty();

  PromoPage? _promoPage;

  @override
  void onInit() async {
    super.onInit();

    fetch(true);
  }

  void fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      promos.clear();

      _promoPage = null;
    } else if (_promoPage != null &&
        (_promoPage!.page! >= _promoPage!.pages! ||
            _promoPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _promoPage == null ? 1 : _promoPage!.page! + 1;

      var query = {
        'page': page.toString(),
        'type': 'available',
      };

      _promoPage = (await _promoApi.retrieve(query)).data!.promoPage;

      promos.addAll(_promoPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }
}
