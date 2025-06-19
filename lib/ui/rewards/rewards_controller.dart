// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/reward_api.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/reward.dart';
import 'package:baustaka/model/reward_page.dart';

import 'package:baustaka/ui/state/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

class RewardsController extends GetxController {
  var isFetching = false.obs;
  var isLiking = false.obs;

  RxList<Reward> rewards = RxList.empty();

  RewardApi rewardApi = Get.put(RewardApi());

  String? points;

  RewardPage? _rewardPage;

  Rx<firebase_auth.User?> firebaseUser = Rx(null);

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  // final _authApi = Get.put(AuthApi());

  @override
  void onInit() async {
    super.onInit();

    // Initialize Firebase user from session
    try {
      firebaseUser.value = Session.user;
      if (firebaseUser.value == null) {
        throw 'Please log in';
      }
      
      // Listen to state controller for user updates
      stateController.addUserListener((newUser) {
        // This callback receives the app User from state controller
        // We'll trigger a refresh when the user data changes
        if (newUser != null && rewards.isEmpty) {
          fetch(true);
        }
      });
    } catch (e) {
      Util.toast('Authentication required. Please log in.');
      await Session.logout();
      return;
    }

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
      // Check if Firebase user is still valid
      if (firebaseUser.value == null) {
        throw 'Please log in';
      }

      // if (refresh) user.value = (await _authApi.auth()).data!.user;

      int page = _rewardPage == null ? 1 : _rewardPage!.page! + 1;

      _rewardPage = (await rewardApi.retrieve({
        'userId': firebaseUser.value!.uid, // Use Firebase UID since we don't have backend user ID
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
