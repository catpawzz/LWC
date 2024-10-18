import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

void main() {
  Client client = Client();
  client
      .setEndpoint('https://backend.srv2.catpawz.net/v1')
      .setProject('670bf524002adc879216')
      .setSelfSigned(status: false);

  runApp(MainApp(client: client));
}

class MainApp extends StatelessWidget {
  final Client client;

  const MainApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(client: client),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final Client client;

  const LoginScreen({super.key, required this.client});

  void _loginWithGitHub(BuildContext context) async {
    Account account = Account(client);

    try {
      await account.createOAuth2Session(provider: OAuthProvider.github);
      // Navigate to the home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login to CEDU')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _loginWithGitHub(context),
          child: const Text('Login with GitHub'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}