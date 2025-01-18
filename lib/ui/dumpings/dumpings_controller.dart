// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/dumping_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/dumping.dart';
import 'package:baustaka/model/dumping_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:get/get.dart';

class DumpingsController extends GetxController {
  var isFetching = false.obs;

  final _dumpingApi = Get.put(DumpingApi());

  RxList<Dumping> dumpings = RxList.empty();

  DumpingPage? _dumpingPage;

  RxString status = RxString('All');

  Rx<User?> user = Rx(null);

  // final _authApi = Get.put(AuthApi());

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      dumpings.clear();

      _dumpingPage = null;
    } else if (_dumpingPage != null &&
        (_dumpingPage!.page! >= _dumpingPage!.pages! ||
            _dumpingPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      // if (refresh) user.value = (await _authApi.auth()).data!.user;

      int page = _dumpingPage == null ? 1 : _dumpingPage!.page! + 1;

      Map<String, dynamic> query = {
        'userId': user.value!.id,
        'page': page.toString(),
      };

      if (status.value != 'All') {
        query.addAll({'status': status.value.toLowerCase()});
      }

      _dumpingPage = (await _dumpingApi.retrieve(query)).data!.dumpingPage;

      dumpings.addAll(_dumpingPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
