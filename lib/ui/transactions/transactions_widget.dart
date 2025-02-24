import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
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
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          TextButton(
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
            child: Obx(
              () => controller.isDepositing.isTrue
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Top up'),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetch(true);
          await controller.fetchWalletData();
        },
        child: Obx(
          () {
            return ListView(
              children: [
                // Wallet Summary Card
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Available',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Ksh ${controller.balance.value}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Palette.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Transactions Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // If no transactions, show an empty widget
                if (controller.transactions.isEmpty &&
                    !controller.isFetching.value)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: const Text('No transactions'),
                    ),
                  ),
                // List of Transactions
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItemWidget(
                      transaction: controller.transactions[index],
                    );
                  },
                ),
                if (controller.isFetching.value)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
