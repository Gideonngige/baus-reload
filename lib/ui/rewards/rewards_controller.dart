// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/reward_api.dart';
import 'package:baustaka/api/transaction_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/reward.dart';
import 'package:baustaka/model/reward_page.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

class RewardsController extends GetxController {
  var isFetching = false.obs;
  var isLiking = false.obs;
  var isFetchingWallet = false.obs;

  RxList<Reward> rewards = RxList.empty();
  RxList<Transaction> transactions = RxList.empty();

  RewardApi rewardApi = Get.put(RewardApi());
  TransactionApi transactionApi = Get.put(TransactionApi());

  String? points;

  RewardPage? _rewardPage;

  Rx<firebase_auth.User?> firebaseUser = Rx(null);
  StateController stateController = Get.find<StateController>();

  double walletBalance = 0.0;

  // final _authApi = Get.put(AuthApi());

  @override
  void onInit() {
    super.onInit();

    try {
      // Get Firebase user
      firebaseUser.value = firebase_auth.FirebaseAuth.instance.currentUser;

      // Listen to state controller for user updates
      stateController.addUserListener((newUser) {
        // This callback receives the app User from state controller
        // We'll trigger a refresh when the user data changes and has an ID
        if (newUser?.id != null) {
          fetch(true);
          fetchWalletData();
        }
      });

      // Initial fetch if user is already available
      if (stateController.user?.id != null) {
        fetch(true);
        fetchWalletData();
      }
    } catch (e) {
      print('Error in onInit: $e');
    }
  }

  // Sync with backend to get MongoDB user data
  Future<void> syncWithBackend() async {
    try {
      if (firebaseUser.value?.uid == null) return;

      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/firebase',
        data: {
          'uid': firebaseUser.value!.uid,
          'email': firebaseUser.value!.email,
        },
      );

      if (response.data['user'] != null) {
        // Update state controller with the user data
        final userData = response.data['user'];
        print('Synced user data: $userData');
        
        // This should trigger the user listener above
        // stateController.updateUser(User.fromJson(userData));
      }
    } catch (e) {
      print('Error syncing with backend: $e');
    }
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

      // Check if we have the app user data with MongoDB ObjectId
      if (stateController.user?.id == null) {
        // Try to sync with backend if we don't have user data
        await syncWithBackend();
        
        if (stateController.user?.id == null) {
          throw 'User data not loaded. Please try again.';
        }
      }

      // if (refresh) user.value = (await _authApi.auth()).data.user;

      // points = user.value?.points.toString();

      final rewardPageResponse = await rewardApi.retrieve({
        'userId': stateController.user!.id, // Use MongoDB ObjectId
        'page': (_rewardPage?.page ?? 0) + 1,
      });

      _rewardPage = rewardPageResponse.data?.rewardPage;

      if (_rewardPage != null) {
        if (refresh) {
          rewards.assignAll(_rewardPage!.docs!);
        } else {
          rewards.addAll(_rewardPage!.docs!);
        }
      }
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  fetchWalletData() async {
    if (isFetchingWallet.isTrue) return;

    isFetchingWallet.value = true;

    try {
      if (firebaseUser.value?.uid == null) {
        throw 'Please log in';
      }

      // Use Dio directly to call the wallet endpoint
      final dioResponse = await Dio().get(
        '${kBaseApiUrl}v1/transaction/wallet',
        queryParameters: {'uid': firebaseUser.value!.uid},
      );
      
      print('Wallet API response: ${dioResponse.data}');
      
      if (dioResponse.data != null && dioResponse.data is Map<String, dynamic>) {
        final data = dioResponse.data as Map<String, dynamic>;
        
        // Handle balance
        if (data.containsKey('balance')) {
          if (data['balance'] is num) {
            walletBalance = (data['balance'] as num).toDouble();
          } else {
            walletBalance = 0.0;
          }
        }
        
        // Handle transactions
        if (data['transactions'] != null && data['transactions'] is List) {
          final transactionsList = data['transactions'] as List;
          final validTransactions = transactionsList
              .where((item) => item is Map<String, dynamic>)
              .map((json) {
                try {
                  return Transaction.fromJson(json as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing transaction: $e');
                  return null;
                }
              })
              .where((tx) => tx != null)
              .cast<Transaction>()
              .toList();
          
          transactions.assignAll(validTransactions);
        } else {
          transactions.clear();
        }
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
      Util.toast('Failed to load wallet data');
    }

    isFetchingWallet.value = false;
  }
}
