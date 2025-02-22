import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahProdukPage extends StatefulWidget {
  @override
  _TambahProdukPageState createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  Future<void> _tambahProduk() async {
    if (_formKey.currentState!.validate()) {
      final String namaProduk = _namaProdukController.text;
      final int harga = int.parse(_hargaController.text);
      final int stok = int.parse(_stokController.text);

      try {
        await Supabase.instance.client.from('produk').insert({
          'NamaProduk': namaProduk,
          'Harga': harga,
          'Stok': stok,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil ditambahkan')),
        );

        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(221, 100, 97, 97),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaProdukController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Nama produk wajib diisi' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Stok wajib diisi' : null,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _tambahProduk,
                child: Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
