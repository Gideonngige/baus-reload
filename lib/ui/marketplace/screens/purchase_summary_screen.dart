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
  final Map<String, dynamic>? sellerInfo;
  final String? shipmentNote;

  const PurchaseSummaryScreen({
    super.key,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.paymentMethod = 'M-Pesa',
    this.sellerInfo,
    this.shipmentNote,
  });

  double get totalAmount => price * quantity;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Purchase Summary",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                child: Icon(Icons.check_circle_outline_rounded,
                    color: Palette.primary, size: 100),
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
                    if (sellerInfo != null) ...[
                      const Divider(),
                      _buildRow("Seller Name:", sellerInfo!['name'] ?? "N/A"),
                      _buildRow("Seller Phone:", sellerInfo!['phone'] ?? "N/A"),
                      Padding(
  padding: const EdgeInsets.symmetric(vertical: 6),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120, // fixed width for the label
        child: Text(
          "Seller Location:",
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          sellerInfo!['location'] ?? "N/A",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          softWrap: true,
        ),
      ),
    ],
  ),
),

                    ],
                    if (shipmentNote != null) ...[
                      const Divider(),
                      _buildRow("Note:", shipmentNote!, valueColor: Colors.orange[800]),
                    ],
                    const Divider(thickness: 1.5),
                    _buildRow(
                      "Total Amount:",
                      "Ksh. ${price.toStringAsFixed(2)}",
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
                      sellerInfo: sellerInfo,
                      shipmentNote: shipmentNote,
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

  Widget _buildRow(
  String label,
  String value, {
  bool isBold = false,
  Color? valueColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        SizedBox(
          width: 120, // fixed width for alignment
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Value (wraps safely)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? Colors.black87,
              fontSize: 15,
            ),
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
    Map<String, dynamic>? sellerInfo,
    String? shipmentNote,
    required BuildContext context,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("BAUS TAKA",
                      style: pw.TextStyle(
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green800)),
                  pw.Text("RECEIPT",
                      style: pw.TextStyle(
                          fontSize: 22, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 2, color: PdfColors.grey400),
              pw.SizedBox(height: 16),
              pw.Text("Purchase Details",
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green700)),
              pw.SizedBox(height: 12),
              _pdfRow("Item", itemName),
              _pdfRow("Cost per unit", "Ksh. ${price.toStringAsFixed(2)}"),
              _pdfRow("Quantity", quantity.toString()),
              _pdfRow("Payment Method", paymentMethod),
              _pdfRow("Date", date),
              if (sellerInfo != null) ...[
                _pdfRow("Seller Name", sellerInfo['name'] ?? "N/A"),
                _pdfRow("Seller Phone", sellerInfo['phone'] ?? "N/A"),
                _pdfRow("Seller Location", sellerInfo['location'] ?? "N/A"),
              ],
              if (shipmentNote != null) _pdfRow("Note", shipmentNote, valueColor: PdfColors.orange),
              pw.Divider(thickness: 1.5, color: PdfColors.grey400),
              pw.SizedBox(height: 6),
              _pdfRow("Total Amount", "Ksh. ${total.toStringAsFixed(2)}",
                  isBold: true, valueColor: PdfColors.green800),
              pw.SizedBox(height: 30),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 12),
              pw.Center(
                  child: pw.Text("Thank you for shopping with Baus Taka!",
                      style: pw.TextStyle(fontSize: 14))),
              pw.SizedBox(height: 4),
              pw.Center(
                  child: pw.Text("Contact us: support@baustaka.com",
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700))),
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

  pw.Widget _pdfRow(String label, String value,
      {bool isBold = false, PdfColor? valueColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 14, color: PdfColors.grey800)),
          pw.Text(
            value,
            style: pw.TextStyle(
                fontSize: 14,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: valueColor ?? PdfColors.black),
          ),
        ],
      ),
    );
  }
}
