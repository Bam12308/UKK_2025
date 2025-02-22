import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<void> printStrukPDF(BuildContext context, int penjualanId, List<Map<String, dynamic>> detailPenjualanList, double totalSubtotal) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("======= Struk Pembelian =======", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text("Detail Penjualan ID: $penjualanId"),
            pw.Divider(),
            for (var detail in detailPenjualanList)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Produk: ${detail['ProdukID']}"),
                  pw.Text("Jumlah: ${detail['JumlahProduk']}"),
                  pw.Text("Subtotal: Rp ${detail['Subtotal'].toStringAsFixed(2)}"),
                  pw.Divider(),
                ],
              ),
            pw.Text("Total: Rp ${totalSubtotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text("======= Terima Kasih ======="),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/struk_penjualan_$penjualanId.pdf");
  await file.writeAsBytes(await pdf.save());

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Struk disimpan di: ${file.path}")),
  );
}
