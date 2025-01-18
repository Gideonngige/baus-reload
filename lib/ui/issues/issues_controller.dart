// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/issue_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/model/issue_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:get/get.dart';

class IssuesController extends GetxController {
  var isFetching = false.obs;

  final _issueApi = Get.put(IssueApi());

  RxList<Issue> issues = RxList.empty();

  IssuePage? _issuePage;

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
      issues.clear();

      _issuePage = null;
    } else if (_issuePage != null &&
        (_issuePage!.page! >= _issuePage!.pages! ||
            _issuePage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      // if (refresh) user.value = (await _authApi.auth()).data!.user;

      int page = _issuePage == null ? 1 : _issuePage!.page! + 1;

      Map<String, dynamic> query = {
        'userId': user.value!.id,
        'page': page.toString(),
      };

      if (status.value != 'All') {
        query.addAll({'status': status.value.toLowerCase()});
      }

      _issuePage = (await _issueApi.retrieve(query)).data!.issuePage;

      issues.addAll(_issuePage!.docs!);
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
