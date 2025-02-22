import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailpenjualan.dart'; // Import halaman detail

class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List<Map<String, dynamic>> penjualanList = [];
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
    fetchProduk();
    fetchPelanggan();
  }

  Future<void> fetchPenjualan() async {
    try {
      final response = await Supabase.instance.client.from('penjualan').select();
      setState(() {
        penjualanList = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data penjualan: $error')),
      );
    }
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

  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $error')),
      );
    }
  }

  void _addPenjualan() {
    String? selectedProdukId;
    String? selectedPelangganId;
    final TextEditingController jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Penjualan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedProdukId,
                items: produkList.map((produk) {
                  return DropdownMenuItem(
                    value: produk['ProdukID'].toString(),
                    child: Text(produk['NamaProduk']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProdukId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Pilih Produk'),
              ),
              DropdownButtonFormField<String>(
                value: selectedPelangganId,
                items: pelangganList.map((pelanggan) {
                  return DropdownMenuItem(
                    value: pelanggan['PelangganID'].toString(),
                    child: Text(pelanggan['NamaPelanggan']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPelangganId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Pilih Pelanggan'),
              ),
              TextField(
                controller: jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (selectedProdukId == null || selectedPelangganId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan pilih produk dan pelanggan')),
                  );
                  return;
                }

                final jumlah = int.tryParse(jumlahController.text) ?? 0;
                final tanggalPenjualan = DateTime.now().toIso8601String();
                final selectedProduk = produkList.firstWhere((p) => p['ProdukID'].toString() == selectedProdukId);
                final totalHarga = jumlah * selectedProduk['Harga'];

                try {
                  final response = await Supabase.instance.client.from('penjualan').insert({
                    'TanggalPenjualan': tanggalPenjualan,
                    'TotalHarga': totalHarga,
                    'PelangganID': int.parse(selectedPelangganId!),
                  }).select().single();

                  final penjualanId = response['PenjualanID'];

                  await Supabase.instance.client.from('detailpenjualan').insert({
                    'PenjualanID': penjualanId,
                    'ProdukID': int.parse(selectedProdukId!),
                    'JumlahProduk': jumlah,
                    'Subtotal': totalHarga,
                  });

                  final newStok = selectedProduk['Stok'] - jumlah;

                  await Supabase.instance.client.from('produk').update({
                    'Stok': newStok,
                  }).eq('ProdukID', selectedProduk['ProdukID']);

                  Navigator.of(context).pop();
                  fetchPenjualan();
                  fetchProduk();
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan penjualan: $error')),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addPenjualan,
        child: const Icon(Icons.add),
      ),
      body: penjualanList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: penjualanList.length,
              itemBuilder: (context, index) {
                final penjualan = penjualanList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPenjualanPage(
                          penjualanId: penjualan['PenjualanID'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.black12,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal: ${penjualan['TanggalPenjualan']}',
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('Total Harga: Rp ${penjualan['TotalHarga']}',
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          Text('Pelanggan ID: ${penjualan['PelangganID']}',
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          const SizedBox(height: 5),
                          Text(
                            'Klik untuk lihat detail',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
