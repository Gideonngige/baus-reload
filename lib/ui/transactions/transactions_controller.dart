import 'package:baustaka/api/transaction_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:baustaka/model/transaction_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
    // Add a small delay to ensure proper initialization
    await Future.delayed(const Duration(milliseconds: 100));
    
    // First check if user is logged in
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in during transactions init');
      return;
    }
    
    try {
      // Fetch wallet data first (this is more reliable)
      await fetchWalletData();
      // Then try to fetch paginated transactions if user.value is set
      if (user.value?.id != null) {
    await fetch(true);
      }
    } catch (e) {
      print('Error during transactions controller init: $e');
    }
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
      // Check if user is available
      if (user.value?.id == null) {
        final firebaseUser = auth.FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          Util.toast('User not logged in');
          isFetching.value = false;
          return;
        }
        // For now, we'll skip the paginated fetch if user.value is not properly set
        // and rely on fetchWalletData instead
        isFetching.value = false;
        return;
      }
      
      int page = _transactionPage == null ? 1 : _transactionPage!.page! + 1;
      _transactionPage = (await transactionApi.retrieve({
        'userId': user.value!.id,
        'page': page.toString(),
      }))
          .data!
          .transactionPage;
      transactions.addAll(_transactionPage!.docs!);
    } catch (e) {
      print('Fetch transactions error: $e');
      Util.toast('Failed to load transactions');
    }
    isFetching.value = false;
  }

  /// Fetches the wallet balance and completed transactions using the user ID.
  // Future<void> fetchWalletData() async {
  //   try {
  //     final userId = user.value?.id;
  //     if (userId == null) {
  //       Util.toast('User not logged in');
  //       return;
  //     }
  //     // Call the new wallet endpoint
  //     final dioResponse = await Dio().get(
  //       '${kBaseApiUrl}v1/user/wallet',
  //       queryParameters: {'userId': userId},
  //     );
  //     final data = dioResponse.data;
  //     // Update the balance observable
  //     balance.value = data['balance'] ?? 0;
  //     // Replace the transaction list with the wallet’s completed transactions
  //     transactions.assignAll((data['transactions'] as List)
  //         .map((json) => Transaction.fromJson(json))
  //         .toList());
  //   } catch (e) {
  //     Util.toast(e.toString());
  //   }
  // }

  Future<void> fetchWalletData() async {
    try {
      // Use FirebaseAuth directly to get the uid if your observable isn't set
      final firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        print('User not logged in');
        return;
      }
      final userId = firebaseUser.uid;

      print('Fetching wallet data for user: $userId');

      final dioResponse = await Dio().get(
        '${kBaseApiUrl}v1/transaction/wallet',
        queryParameters: {'uid': userId},
      );
      
      print('Wallet API response status: ${dioResponse.statusCode}');
      print('Wallet API response data: ${dioResponse.data}');
      
      // Check if response data is valid
      if (dioResponse.data == null) {
        print('No wallet data in response');
        balance.value = 0;
        transactions.clear();
        return;
      }
      
      final data = dioResponse.data;
      
      // Safely handle the response data
      if (data is Map<String, dynamic>) {
        // Handle balance - this is the critical part
        if (data.containsKey('balance')) {
          if (data['balance'] is int) {
            balance.value = data['balance'];
          } else if (data['balance'] is double) {
            balance.value = (data['balance'] as double).round();
          } else if (data['balance'] is String) {
            balance.value = int.tryParse(data['balance']) ?? 0;
          } else {
            balance.value = 0;
          }
          print('Balance loaded successfully: ${balance.value}');
        } else {
          print('No balance field in response');
          balance.value = 0;
        }
        
        // Handle transactions array - this is optional
        try {
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
            print('Loaded ${validTransactions.length} transactions');
          } else {
            transactions.clear();
            print('No transactions in response or invalid format');
          }
        } catch (e) {
          print('Error loading transactions (non-critical): $e');
          transactions.clear();
        }
      } else {
        print('Response data is not a Map: ${data.runtimeType}');
        // Try to handle different response formats
        balance.value = 0;
        transactions.clear();
      }
      
      print('Wallet data loaded - Balance: ${balance.value}, Transactions: ${transactions.length}');
    } catch (e) {
      print('Wallet fetch error: $e');
      // Only show error toast if it's a real network/critical error
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection') ||
          e.toString().contains('Network')) {
        Util.toast('Network error loading wallet');
      } else {
        print('Non-critical wallet error, not showing toast: $e');
        // Set default values instead of showing error
        balance.value = 0;
        transactions.clear();
      }
    }
  }

  Future<void> withdraw() async {
    if (isWithdrawing.isTrue) return;
    isWithdrawing.value = true;
    try {
      if (amount.text.trim().isEmpty) {
        Util.toast('Please enter withdrawal amount');
        return;
      }
      
      var response = await transactionApi.create({
        'amount': amount.text,
        'type': 'withdrawal',
      });
      
      var transaction = response.data?.transaction;
      if (transaction != null) {
        Util.toast('We are processing your request');
        amount.clear();
        await fetchWalletData();
        if (user.value?.id != null) {
          await fetch(true);
        }
      } else {
        Util.toast('Failed to process withdrawal');
      }
    } catch (e) {
      print('Withdrawal error: $e');
      Util.toast('Failed to process withdrawal');
    }
    isWithdrawing.value = false;
  }

  Future<void> deposit() async {
    if (isDepositing.isTrue) return;
    isDepositing.value = true;
    try {
      if (amountToDeposit.text.trim().isEmpty) {
        Util.toast('Please enter deposit amount');
        return;
      }
      
      var response = await transactionApi.create({
        'amount': amountToDeposit.text,
        'type': 'deposit',
      });
      
      var transaction = response.data?.transaction;
      if (transaction != null) {
        Util.toast('We are processing your request');
        amountToDeposit.clear();
        await fetchWalletData();
        if (user.value?.id != null) {
          await fetch(true);
        }
      } else {
        Util.toast('Failed to process deposit');
      }
    } catch (e) {
      print('Deposit error: $e');
      Util.toast('Failed to process deposit');
    }
    isDepositing.value = false;
  }
}
