import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:cedu/home/home.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint('https://backend.srv2.catpawz.net/v1')
      .setProject('670bf524002adc879216')
      .setSelfSigned(status: false);

  runApp(LoginPage(client: client));
}

class LoginPage extends StatelessWidget {
  final Client client;

  const LoginPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
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
      Session session = await account.createOAuth2Session(provider: OAuthProvider.github);
      // Store the session token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', session.$id);

      // Navigate to the home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
      appBar: AppBar(
        title: const Text('Login to CEDU'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _loginWithGitHub(context),
          child: const Text('Login with GitHub'),
        ),
      ),
    );
  }
}