// ignore_for_file: use_build_context_synchronously

import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:cedu/home/home.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../inc/api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = ApiClient().client;
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

  void _loginWithO2(BuildContext context, OAuthProvider provider) async {
    vibrateSelection();
    Account account = Account(client);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
          content: Text('Do you want to login with ${provider.name}? \n \nNote: The browser may stay open after you login, so please return to the app manually if it doesn\'t close automatically.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                vibrateSelection();
                Navigator.of(context).pop();
                try {
                  await account.createOAuth2Session(provider: provider);
                  User user = await account.get();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('session', user.$id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  vibrateError();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: (Colors.deepPurple[100])
            ?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Set the status bar color to white
          statusBarIconBrightness:
              Brightness.light, // Set the status bar icons to dark
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Welcome to Learn With Catpawz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can either directly register an account using email/password or login with one of the following OAuth providers.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _loginWithO2(context, OAuthProvider.github),
                icon: const FaIcon(FontAwesomeIcons.github),
                label: const Text('Login with GitHub'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _loginWithO2(context, OAuthProvider.google),
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Login with Google'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _loginWithO2(context, OAuthProvider.discord),
                icon: const FaIcon(FontAwesomeIcons.discord),
                label: const Text('Login with Discord'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
