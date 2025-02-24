import 'package:baustaka/api/transaction_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:baustaka/model/transaction_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baustaka/config/env.dart';

class TransactionsController extends GetxController {
  var isFetching = false.obs;
  var isWithdrawing = false.obs;
  var isDepositing = false.obs;

  RxList<Transaction> transactions = RxList.empty();

  // Existing Transaction API instance
  var transactionApi = Get.put(TransactionApi());

  TransactionPage? _transactionPage;

  Rx<User?> user = Rx(null);

  // Controllers for deposit/withdraw amounts
  TextEditingController amount = TextEditingController();
  TextEditingController amountToDeposit = TextEditingController();

  // New observable for wallet balance
  RxInt balance = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    // Initially load transactions (if any)
    await fetch(true);
    // Also fetch wallet data (balance and completed transactions)
    await fetchWalletData();
  }

  /// Fetches paginated transactions (e.g., when scrolling)
  fetch(bool refresh) async {
    if (isFetching.isTrue) return;
    isFetching.value = true;
    if (refresh) {
      transactions.clear();
      _transactionPage = null;
    } else if (_transactionPage != null &&
        (_transactionPage!.page! >= _transactionPage!.pages! ||
            _transactionPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }
    try {
      // Assuming that user.value has been set (e.g. during login)
      int page = _transactionPage == null ? 1 : _transactionPage!.page! + 1;
      _transactionPage = (await transactionApi.retrieve({
        'userId': user.value!.id,
        'page': page.toString(),
      }))
          .data!
          .transactionPage;
      transactions.addAll(_transactionPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }

  /// Fetches the wallet balance and completed transactions using the user ID.
  Future<void> fetchWalletData() async {
    try {
      final userId = user.value?.id;
      if (userId == null) {
        Util.toast('User not logged in');
        return;
      }
      // Call the new wallet endpoint
      final dioResponse = await Dio().get(
        '${kBaseApiUrl}v1/user/wallet',
        queryParameters: {'userId': userId},
      );
      final data = dioResponse.data;
      // Update the balance observable
      balance.value = data['balance'] ?? 0;
      // Replace the transaction list with the wallet’s completed transactions
      transactions.assignAll((data['transactions'] as List)
          .map((json) => Transaction.fromJson(json))
          .toList());
    } catch (e) {
      Util.toast(e.toString());
    }
  }

  Future<void> withdraw() async {
    if (isWithdrawing.isTrue) return;
    isWithdrawing.value = true;
    try {
      var transaction = (await transactionApi.create({
        'amount': amount.text,
        'type': 'withdrawal',
      }))
          .data!
          .transaction;
      if (transaction != null) {
        Util.toast('We are processing your request');
        await fetch(true);
        // Optionally, refresh wallet data to update balance
        await fetchWalletData();
      }
    } catch (e) {
      Util.toast(e);
    }
    isWithdrawing.value = false;
  }

  Future<void> deposit() async {
    if (isDepositing.isTrue) return;
    isDepositing.value = true;
    try {
      var transaction = (await transactionApi.create({
        'amount': amountToDeposit.text,
        'type': 'deposit',
      }))
          .data!
          .transaction;
      if (transaction != null) {
        Util.toast('We are processing your request');
        await fetch(true);
        await fetchWalletData();
      }
    } catch (e) {
      Util.toast(e);
    }
    isDepositing.value = false;
  }
}
