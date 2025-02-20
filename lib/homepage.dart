import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black),
          bodyLarge: TextStyle(
              fontFamily: 'Poppins', fontSize: 18, color: Colors.black54),
          labelLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Tombol hitam
            minimumSize: Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Widget _buildButton(
      BuildContext context, String label, IconData icon, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 14, 8, 8)),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Jempol',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Selamat datang di Toko Jempol!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildButton(
                context, 'Penjualan', Icons.shopping_cart, PenjualanPage()),
            SizedBox(height: 20),
            _buildButton(context, 'Pelanggan', Icons.people,
                PelangganPage(namaPelanggan: 'John Doe')),
            SizedBox(height: 20),
            _buildButton(context, 'Produk', Icons.list, ProdukPage()),
          ],
        ),
      ),
    );
  }
}

class PenjualanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Penjualan',
              style: TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Penjualan:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Map<String, dynamic>> produkList = [
    {"NamaProduk": "Meja", "Harga": 500000, "Stok": 10},
    {"NamaProduk": "Kursi", "Harga": 250000, "Stok": 20},
    {"NamaProduk": "Pintu", "Harga": 1000000, "Stok": 7},
  ];

  // List untuk menyimpan produk yang dibeli (keranjang belanja)
  List<Map<String, dynamic>> keranjang = [];

  void beliProduk(int index) {
    setState(() {
      if (produkList[index]['Stok'] > 0) {
        produkList[index]['Stok']--; // Mengurangi stok
        keranjang.add(produkList[index]); // Menambahkan produk ke keranjang
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Berhasil membeli ${produkList[index]['NamaProduk']}! Sisa stok: ${produkList[index]['Stok']}"),
          duration: Duration(seconds: 2),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Maaf, stok ${produkList[index]['NamaProduk']} habis!"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        actions: [
          // Tombol untuk membuka keranjang belanja
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigasi ke halaman Keranjang
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KeranjangPage(keranjang: keranjang),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: produkList.length,
          itemBuilder: (context, index) {
            final produk = produkList[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          produk['NamaProduk'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.shopping_cart, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Harga: Rp ${produk['Harga']}',
                        style: TextStyle(fontSize: 16)),
                    Text('Stok: ${produk['Stok']}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => beliProduk(index),
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Beli"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Halaman Keranjang
class KeranjangPage extends StatelessWidget {
  final List<Map<String, dynamic>> keranjang;

  KeranjangPage({required this.keranjang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: keranjang.isEmpty
          ? Center(
              child: Text('Keranjang belanja kosong',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: keranjang.length,
                itemBuilder: (context, index) {
                  final produk = keranjang[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk['NamaProduk'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Harga: Rp ${produk['Harga']}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class PelangganPage extends StatelessWidget {
  final String namaPelanggan;

  PelangganPage({required this.namaPelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelanggan - $namaPelanggan',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Halaman Pelanggan',
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
