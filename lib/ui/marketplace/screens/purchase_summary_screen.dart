import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:baustaka/config/palette.dart';


class PurchaseSummaryScreen extends StatelessWidget {
    final String itemName;
    final double price;
    final int quantity;
    final String paymentMethod;

    const PurchaseSummaryScreen({
        super.key,
        required this.itemName,
        required this.price,
        required this.quantity,
        this.paymentMethod = 'M-Pesa',
    });

    double get totalAmount => price * quantity;

    @override
    Widget build(BuildContext context) {
        final formattedDate = DateFormat.yMMMd().format(DateTime.now());

        return Scaffold(
            appBar: AppBar(
                title: const Text(
                    "Purchase Summary",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                ),
                centerTitle: true,
                backgroundColor: Palette.primary,
                iconTheme: const IconThemeData(color: Colors.white),
            ),
            
            body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Center(
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Palette.primary,
            size: 100,
          ),
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text(
            "Purchase Successful!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow("Item Purchased:", itemName),
              const Divider(),
              _buildRow("Cost per Unit:", "Ksh. ${price.toStringAsFixed(2)}"),
              const Divider(),
              _buildRow("Quantity:", quantity.toString()),
              const Divider(),
              _buildRow("Payment Method:", paymentMethod),
              const Divider(),
              _buildRow("Date:", formattedDate),
              const Divider(thickness: 1.5),
              _buildRow(
                "Total Amount:",
                "Ksh. ${totalAmount.toStringAsFixed(2)}",
                isBold: true,
                valueColor: Colors.green[800],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _generateReceipt(
                itemName: itemName,
                price: price,
                quantity: quantity,
                total: totalAmount,
                date: formattedDate,
                paymentMethod: paymentMethod,
                context: context,
              );
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            label: const Text(
              "Download Receipt",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
  ),
),

        );
    }

    Widget _buildRow(String label, String value, {bool isBold = false, Color? valueColor}){
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                        label,
                        style: const TextStyle(fontSize: 15, color: Colors.black54)
                    ),
                    Text(
                        value,
                        style: TextStyle(
                            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                            color: valueColor ?? Colors.black87,
                            fontSize: 15,
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> _generateReceipt({
        required String itemName,
        required double price,
        required int quantity,
        required double total,
        required String date,
        required String paymentMethod,
        required BuildContext context,


    }) async {
        final pdf = pw.Document();

        pdf.addPage(
            pw.Page(
                build: (pw.Context context) => pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Text(
                                "BAUS TAKA RECEIPT",
                                style:pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green700
                                )
                                ),
                            pw.SizedBox(height: 20),
                            pw.Text("Item: $itemName"),
                            pw.Text("Cost per unit: Ksh. ${price.toStringAsFixed(2)}"),
                            pw.Text("Quantity: $quantity"),
                            pw.Text("Payment Method: $paymentMethod"),
                            pw.Text("Date: $date"),
                            pw.Divider(),
                            pw.Text("Total: Ksh. ${total.toStringAsFixed(2)}",
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green800
                            )
                            ),
                            pw.SizedBox(height: 30),
                            pw.Text(
                                "Thank you for using Baus Taka!",
                                style: const pw.TextStyle(fontSize: 14),
                            ),

                        ],
                    ),
                ),
            ),
        );

        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/receipt.pdf");
        await file.writeAsBytes(await pdf.save());

        await OpenFile.open(file.path);
    }
}