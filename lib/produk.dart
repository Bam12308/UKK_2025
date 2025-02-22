import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/penjualan/detailpenjualan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _selectedPage = ProdukTab();

  void _navigateToPage(Widget page) {
    setState(() {
      _selectedPage = page;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 129, 156, 183),
        title: Text('Bams Furniture',
            style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 42, 55, 61),
                fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text('Bams Furniture',
                  style: GoogleFonts.domine(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Produk'),
              onTap: () => _navigateToPage(ProdukTab()),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Penjualan'),
              onTap: () => _navigateToPage(PenjualanPage()),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pelanggan'),
              onTap: () => _navigateToPage(PelangganPage()),
            ),
          ],
        ),
      ),
      body: _selectedPage,
    );
  }
}

class ProdukTab extends StatefulWidget {
  @override
  _ProdukTabState createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        products = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data produk: $error')),
      );
    }
  }

  void _deleteProduct(int produkID) {
    print("Menghapus produk dengan ID: $produkID"); // Debugging
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog sebelum eksekusi
                try {
                  await Supabase.instance.client
                      .from('produk')
                      .delete()
                      .eq('ProdukID', produkID);

                  print(
                      "Produk dengan ID $produkID berhasil dihapus"); // Debugging

                  fetchProduk(); // Refresh data setelah menghapus

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Produk berhasil dihapus')),
                  );
                } catch (error) {
                  print("Error: $error"); // Debugging
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus produk: $error')),
                  );
                }
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _addOrEditProduct({Map<String, dynamic>? product}) {
    final TextEditingController namaController =
        TextEditingController(text: product?['NamaProduk'] ?? '');
    final TextEditingController hargaController =
        TextEditingController(text: product?['Harga']?.toString() ?? '');
    final TextEditingController stokController =
        TextEditingController(text: product?['Stok']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Produk')),
              TextField(
                  controller: hargaController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: stokController,
                  decoration: const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                final namaProduk = namaController.text;
                final harga = int.tryParse(hargaController.text) ?? 0;
                final stok = int.tryParse(stokController.text) ?? 0;

                if (product == null) {
                  await Supabase.instance.client.from('produk').insert({
                    'NamaProduk': namaProduk,
                    'Harga': harga,
                    'Stok': stok,
                  });
                } else {
                  await Supabase.instance.client.from('produk').update({
                    'NamaProduk': namaProduk,
                    'Harga': harga,
                    'Stok': stok,
                  }).eq('ProdukID', product['ProdukID']);
                }
                Navigator.of(context).pop();
                fetchProduk();
              },
              child: Text(product == null ? 'Tambah' : 'Simpan'),
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
        backgroundColor: Colors.blueAccent,
        onPressed: () => _addOrEditProduct(),
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Produk',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: products.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: ListTile(
                            title: Text(product['NamaProduk'],
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Rp ${product['Harga']} | Stok: ${product['Stok']}',
                                style: GoogleFonts.poppins(fontSize: 14)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () =>
                                        _addOrEditProduct(product: product)),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _deleteProduct(product['ProdukID']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
