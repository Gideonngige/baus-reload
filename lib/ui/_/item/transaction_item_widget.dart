import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemWidget({super.key, required this.transaction});

  IconData _getTransactionIcon() {
    switch (transaction.type?.toLowerCase()) {
      case 'deposit':
        return Icons.add_circle_outline;
      case 'withdrawal':
        return Icons.remove_circle_outline;
      case 'payment':
        return Icons.payment;
      case 'refund':
        return Icons.keyboard_return;
      default:
        return Icons.receipt_long;
    }
  }

  Color _getTransactionColor() {
    if (transaction.status?.toLowerCase() == 'completed') {
      switch (transaction.type?.toLowerCase()) {
        case 'deposit':
        case 'refund':
          return Colors.green;
        case 'withdrawal':
        case 'payment':
          return Colors.red;
        default:
          return kAppTheme.primaryColor;
      }
    } else if (transaction.status?.toLowerCase() == 'pending') {
      return Colors.orange;
    } else if (transaction.status?.toLowerCase() == 'failed') {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _getAmountDisplay() {
    final amount = transaction.amount ?? 0;
    final fees = transaction.fees ?? 0;
    final total = amount + fees;
    
    switch (transaction.type?.toLowerCase()) {
      case 'deposit':
      case 'refund':
        return '+Ksh ${total.abs().toStringAsFixed(0)}';
      case 'withdrawal':
      case 'payment':
        return '-Ksh ${total.abs().toStringAsFixed(0)}';
      default:
        return 'Ksh ${total.abs().toStringAsFixed(0)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async =>
          await Get.toNamed('${Routes.kTransaction}${transaction.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Transaction Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTransactionColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTransactionIcon(),
                color: _getTransactionColor(),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type?.capitalize ?? 'Transaction',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        Util.formatDate(transaction.createdAt, withTime: true),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getTransactionColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          transaction.status?.capitalize ?? 'Unknown',
                          style: TextStyle(
                            color: _getTransactionColor(),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Amount
            Text(
              _getAmountDisplay(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _getTransactionColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
