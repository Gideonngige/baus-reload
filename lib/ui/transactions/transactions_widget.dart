import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/item/transaction_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsWidget extends ResponsiveWidget<TransactionsController> {
  TransactionsWidget({super.key});

  @override
  String get tag => 'transactions';

  @override
  bool get shouldAdjust => true;

  @override
  TransactionsController get controller =>
      Get.put(TransactionsController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Wallet',
          ),
          actions: [
            TextButton(
              onPressed: () async => await Get.dialog(
                DialogWidget(
                  title: 'Top up',
                  content: 'Enter amount equal to or more than 10 to top up your wallet in Ksh',
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
                      Navigator.of(screen.context).pop();
                    },
                  inputController: controller.amountToDeposit,
                ),
              ),
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
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch(true);
          },
          child: Obx(
            () => NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) controller.fetch(false);
                return false;
              },
              child: controller.user.value != null
                  ? ListView.builder(
                      itemBuilder: (context, index) => index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: const Text(
                                    'Summary',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Available',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        'Ksh ${controller.user.value!.balance!.available}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(screen.context)
                                              .primaryColor,
                                        ),
                                      ),
                                      controller.user.value!.balance!
                                                  .available! >
                                              0
                                          ? Row(
                                              children: [
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await Get.dialog(
                                                      DialogWidget(
                                                        title: 'Withdraw?',
                                                        content:
                                                            'Enter the amount to withdraw',
                                                        onConfirm: () async {
                                                          await controller
                                                              .withdraw();
                                                        },
                                                        hintText: 'Amount',
                                                        inputController:
                                                            controller.amount,
                                                      ),
                                                    );
                                                  },
                                                  child: controller
                                                          .isWithdrawing.isTrue
                                                      ? const CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                        )
                                                      : const Text('Withdraw'),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                if (controller.user.value!.balance!.held != 0)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text('On hold'),
                                        ),
                                        Text(
                                            'Ksh ${controller.user.value!.balance!.held}')
                                      ],
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: const Text(
                                    'Transactions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (controller.transactions.isEmpty)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(48),
                                      child: controller.isFetching.isTrue
                                          ? const CircularProgressIndicator()
                                          : const Text('No transactions'),
                                    ),
                                  ),
                              ],
                            )
                          : TransactionItemWidget(
                              transaction: controller.transactions[index - 1],
                            ),
                      itemCount: controller.transactions.length + 1,
                    )
                  : ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: controller.isFetching.isTrue
                                ? const CircularProgressIndicator()
                                : const Text('No transactions'),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
}
