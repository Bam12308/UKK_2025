import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganPage extends StatefulWidget {
  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
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

  void _addOrEditPelanggan({Map<String, dynamic>? pelanggan}) {
    final TextEditingController namaController =
        TextEditingController(text: pelanggan?['NamaPelanggan'] ?? '');
    final TextEditingController teleponController =
        TextEditingController(text: pelanggan?['NomorTelepon'] ?? '');
    final TextEditingController alamatController =
        TextEditingController(text: pelanggan?['Alamat'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(
            pelanggan == null ? 'Tambah Pelanggan' : 'Edit Pelanggan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: teleponController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                final namaPelanggan = namaController.text;
                final nomorTelepon = teleponController.text;
                final alamat = alamatController.text;

                if (pelanggan == null) {
                  await Supabase.instance.client.from('pelanggan').insert({
                    'NamaPelanggan': namaPelanggan,
                    'NomorTelepon': nomorTelepon,
                    'Alamat': alamat,
                  });
                } else {
                  await Supabase.instance.client.from('pelanggan').update({
                    'NamaPelanggan': namaPelanggan,
                    'NomorTelepon': nomorTelepon,
                    'Alamat': alamat,
                  }).eq('PelangganID', pelanggan['PelangganID']);
                }
                Navigator.of(context).pop();
                fetchPelanggan();
              },
              child: Text(pelanggan == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deletePelanggan(int pelangganId) async {
    try {
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', pelangganId);
      fetchPelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pelanggan berhasil dihapus')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pelanggan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pelanggan'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _addOrEditPelanggan(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: pelangganList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: pelangganList.length,
              itemBuilder: (context, index) {
                final pelanggan = pelangganList[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    title: Text(
                      pelanggan['NamaPelanggan'],
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Telepon: ${pelanggan['NomorTelepon']}', style: GoogleFonts.poppins(fontSize: 14)),
                        Text('Alamat: ${pelanggan['Alamat']}', style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrEditPelanggan(pelanggan: pelanggan),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePelanggan(pelanggan['PelangganID']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
