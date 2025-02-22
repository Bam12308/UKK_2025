import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DetailPenjualanPage extends StatefulWidget {
  final int penjualanId;

  const DetailPenjualanPage({Key? key, required this.penjualanId}) : super(key: key);

  @override
  _DetailPenjualanPageState createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  List<Map<String, dynamic>> detailPenjualanList = [];
  List<Map<String, dynamic>> produkList = [];
  double totalSubtotal = 0.0;

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchDetailPenjualan();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produkList = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data produk: $error')),
      );
    }
  }

  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select()
          .eq('PenjualanID', widget.penjualanId);

      setState(() {
        detailPenjualanList = List<Map<String, dynamic>>.from(response);
        totalSubtotal = detailPenjualanList.fold(
          0.0,
          (sum, item) => sum + (item['Subtotal'] as num).toDouble(),
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data detail penjualan: $error')),
      );
    }
  }

  String getNamaProduk(int produkId) {
    final produk = produkList.firstWhere(
      (p) => p['ProdukID'] == produkId,
      orElse: () => {'NamaProduk': 'Produk Tidak Ditemukan'},
    );
    return produk['NamaProduk'];
  }

  Future<void> printStrukPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Struk Pembelian", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Detail Penjualan ID: ${widget.penjualanId}"),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ["Produk", "Jumlah", "Subtotal"],
                data: detailPenjualanList.map((detail) => [
                  getNamaProduk(detail['ProdukID']),
                  detail['JumlahProduk'].toString(),
                  "Rp ${detail['Subtotal'].toStringAsFixed(2)}",
                ]).toList(),
              ),
              pw.Divider(),
              pw.Text("Total: Rp ${totalSubtotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
      ),
      body: detailPenjualanList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: detailPenjualanList.length,
                    itemBuilder: (context, index) {
                      final detail = detailPenjualanList[index];
                      return Card(
                        color: Colors.black12,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Produk: ${getNamaProduk(detail['ProdukID'])}',
                                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                'Jumlah: ${detail['JumlahProduk']}',
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Subtotal: Rp ${detail['Subtotal'].toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black26,
                  child: Text(
                    'Total Subtotal: Rp ${totalSubtotal.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => printStrukPDF(context),
        child: Icon(Icons.print),
      ),
    );
  }
}
