// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/reward_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/reward.dart';
import 'package:baustaka/model/reward_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:get/get.dart';

class RewardsController extends GetxController {
  var isFetching = false.obs;
  var isLiking = false.obs;

  RxList<Reward> rewards = RxList.empty();

  RewardApi rewardApi = Get.put(RewardApi());

  String? points;

  RewardPage? _rewardPage;

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
      rewards.clear();

      _rewardPage = null;
    } else if (_rewardPage != null &&
        (_rewardPage!.page! >= _rewardPage!.pages! ||
            _rewardPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      // if (refresh) user.value = (await _authApi.auth()).data!.user;

      int page = _rewardPage == null ? 1 : _rewardPage!.page! + 1;

      _rewardPage = (await rewardApi.retrieve({
        'userId': user.value!.id,
        'page': page.toString(),
      }))
          .data!
          .rewardPage;

      rewards.addAll(_rewardPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
