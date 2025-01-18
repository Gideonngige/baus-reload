import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async =>
          await Get.toNamed('${Routes.kTransaction}${transaction.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type!.capitalize!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(
                        '${Util.formatDate(transaction.createdAt, withTime: true)} · ${transaction.status!.capitalize}'),
                  )
                ],
              ),
            ),
            Text(
              (transaction.amount! + transaction.fees!).toString(),
              style: TextStyle(
                fontWeight: transaction.status == 'completed' &&
                        transaction.type == 'withdrawal'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: transaction.status == 'completed' &&
                        transaction.type == 'withdrawal'
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
