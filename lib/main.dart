import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
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

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Simple validation for username and password
    if (username == 'B' && password == '1') {
      // Login successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Berhasil')));

      // Navigate to the HomePage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Login failed
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOKO JEMPOL'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/JariiiiJempol.png'),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a simple HomePage screen that the user is redirected to after login

