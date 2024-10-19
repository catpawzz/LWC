import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:cedu/auth/login.dart';
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
        await account.getSession(sessionId: sessionId);
        // Session is valid, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        // Session is invalid or expired, show login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(client: Client(),)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to CEDU'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}