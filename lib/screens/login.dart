import 'package:flutter/material.dart';
import 'package:logo_game/utils/password_hasher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'signup.dart'; // Import SignupScreen
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  Future<void> _checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUser = prefs.getString('loggedInUser');

    if (loggedInUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    String email = _emailController.text;
    String password = _passwordController.text;

    bool isAuthenticated = users.any((user) {
      final Map<String, dynamic> userData = jsonDecode(user);
      if (userData.containsKey('email') && userData.containsKey('password')) {
        return (userData['email'] == email || userData['username'] == email) &&
            PasswordHasher.verifyPassword(password, userData['password']);
      }
      return false;
    });

    if (isAuthenticated) {
      await prefs.setString('loggedInUser', email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email/username or password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email or Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
