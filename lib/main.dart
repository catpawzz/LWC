// ignore_for_file: use_build_context_synchronously

import 'package:cedu/auth/login.dart';
import 'package:cedu/home/home.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inc/api.dart';
import 'inc/haptic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = ApiClient().client;
  
  runApp(MainApp(client: client));
}

class MainApp extends StatelessWidget {
  final Client client;

  const MainApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MainScreen(client: client),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Client client;

  const MainScreen({super.key, required this.client});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession(context);
  }

  Future<void> _checkSession(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session');

    if (sessionId != null) {
      Account account = Account(widget.client);
      try {
        await account.get();
        // Session is valid, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        // Session is invalid or expired, show login screen
        vibrateError();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text(
                'Session Expired',
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
              content: const Text("Your account has been blocked, deleted or this is the first time you're accessing this app. Please login again."),
              actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              vibrateSelection();
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(client: widget.client)),
              );
            },
          ),
              ],
            );
          },
        );
      }
    } else {
        Navigator.pushReplacement(
          context,
            MaterialPageRoute(builder: (context) => LoginPage(client: widget.client)),
        );
    }

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text('Loading...'),
          ],
        ),
      ),
    );
  }
}