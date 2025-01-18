import 'package:get/get.dart';
import 'package:baustaka/api/product_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/model/product_page.dart';

class ProductsController extends GetxController {
  var isFetching = false.obs;
  var showSearch = false.obs;

  ProductApi productApi = Get.put(ProductApi());

  RxList<Product> products = RxList.empty();

  ProductPage? _productPage;

  String? q;

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      products.clear();

      _productPage = null;
    } else if (_productPage != null &&
        (_productPage!.page! >= _productPage!.pages! ||
            _productPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _productPage == null ? 1 : _productPage!.page! + 1;

      Map<String, dynamic> query = {
        'page': page.toString(),
        'status': 'active'
      };

      if (q != null && q!.trim().isNotEmpty) query.addAll({'q': q!.trim()});

      _productPage = (await productApi.retrieve(query)).data!.productPage;

      products.addAll(_productPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }
}
