import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Supabase dengan URL dan anonKey yang sesuai
  Supabase.initialize(
      url: "https://chxhbocjccmahqlbkbme.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoeGhib2NqY2NtYWhxbGJrYm1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzNzM3MjEsImV4cCI6MjA1Mzk0OTcyMX0.niyAwqI-KHvxokQp5RYa6rzBhvvfypEBzv2Dafy2oTg");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      home: LoginPage(), // Menentukan halaman awal aplikasi
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Fungsi untuk login
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validasi sederhana untuk username dan password
    if (username == 'B' && password == '1') {
      // Jika login berhasil
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Berhasil')));

      // Arahkan ke halaman HomePage setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOKO JEMPOL'), // Judul aplikasi
        centerTitle: true, // Menyelaraskan judul ke tengah
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Memberikan jarak di sekitar widget
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Menyusun elemen secara vertikal
          children: [
            Image.asset('images/JariiiiJempol.png'), // Menampilkan gambar
            TextField(
              controller:
                  _usernameController, // Menghubungkan controller ke input username
              decoration: InputDecoration(
                labelText: 'Username', // Label untuk kolom input
                border: OutlineInputBorder(), // Border di sekitar kolom input
              ),
            ),
            SizedBox(height: 20), // Jarak antar elemen
            TextField(
              controller:
                  _passwordController, // Menghubungkan controller ke input password
              obscureText: true, // Menyembunyikan teks pada kolom password
              decoration: InputDecoration(
                labelText: 'Password', // Label untuk kolom password
                border: OutlineInputBorder(), // Border di sekitar kolom input
              ),
            ),
            SizedBox(height: 20), // Jarak antar elemen
            ElevatedButton(
              onPressed: _login, // Memanggil fungsi _login saat tombol ditekan
              child: Text('Login'), // Teks yang tampil pada tombol
            ),
          ],
        ),
      ),
    );
  }
}
