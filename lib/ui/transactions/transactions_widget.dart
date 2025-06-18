import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/item/transaction_item_widget.dart';
import 'package:baustaka/ui/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsWidget extends StatelessWidget {
  const TransactionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransactionsController controller = Get.put(
      TransactionsController(),
      tag: 'transactions',
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: kAppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
        title: const Text(
          'Wallet', 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Get.dialog(
                DialogWidget(
                  title: 'Top up',
                  content:
                      'Enter amount equal to or more than 10 to top up your wallet in Ksh',
                  hintText: 'Amount',
                  onConfirm: () async {
                    try {
                      await controller.deposit();
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  inputController: controller.amountToDeposit,
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Obx(
              () => controller.isDepositing.isTrue
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Top up',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await controller.fetchWalletData();
          await controller.fetch(true);
          } catch (e) {
            print('Refresh error: $e');
          }
        },
        child: Obx(
          () {
            if (controller.isFetching.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Wallet Balance Card with gradient
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kAppTheme.primaryColor,
                        kAppTheme.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: kAppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                        const Text(
                              'Available Balance',
                          style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ksh ${controller.balance.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Recent Transactions Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all transactions
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: kAppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (controller.transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your transaction history will appear here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.transactions.length > 5 
                              ? 5 
                              : controller.transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionItemWidget(
                              transaction: controller.transactions[index],
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
