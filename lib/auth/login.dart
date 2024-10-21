// ignore_for_file: use_build_context_synchronously

import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:cedu/main/nav.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../inc/api.dart';
import 'dart:html' as html;

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key, required this.client});

  void _loginWithO2(BuildContext context, OAuthProvider provider) async {
    Account account = Account(client);
    try {
      await account.createOAuth2Session(provider: provider);
      User user = await account.get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', user.$id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  void _loginOrRegisterWithEmail(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    Account account =
        Account(client); // Make sure 'client' is initialized correctly
    try {
      // Attempt to log in with email and password
      print('Attempting to log in...');
      await account.createEmailPasswordSession(
          email: email, password: password);
      User user = await account.get();

      // Save session ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', user.$id);

      // Navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      print('Login failed: $e');
      if (e.toString().contains('User not found') ||
          (e is AppwriteException && e.code == 401)) {
        try {
          var uuid = const Uuid();
          String randomUserId = uuid.v4();

          print('User not found. Registering new user...');
          await account.create(
            userId: randomUserId,
            email: email,
            password: password,
            name: email.split('@')[0],
          );

          await account.createEmailPasswordSession(
              email: email, password: password);
          User user = await account.get();

          // Save session ID
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('session', user.$id);

          // Navigate to the main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
        } catch (registerError) {
          // Show an error message if registration fails
          print('Registration failed: $registerError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $registerError')),
          );
        }
      } else {
        // Show a generic login error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  void _loginWithEmail(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }
    Account account =
        Account(client); // Make sure 'client' is initialized correctly
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attempting log-in')),
      );
      await account.createEmailPasswordSession(
          email: email, password: password);
      User user = await account.get();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', user.$id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  void _RegisterWithEmail(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    Account account = Account(client);
    try {
      var uuid = const Uuid();
      String randomUserId = uuid.v4();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attempting registration')),
      );
      await account.create(
        userId: randomUserId,
        email: email,
        password: password,
        name: email.split('@')[0],
      );

      // Log in after registration
      await account.createEmailPasswordSession(
          email: email, password: password);
      User user = await account.get();

      // Save session ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', user.$id);

      // Navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    html.document.title = "Learn With Catpawz | Login";
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login to LWC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: (Colors.deepPurple[100])
            ?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Set the status bar color to white
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Brightness.light, // Set the status bar icons to dark
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Welcome to Learn With Catpawz!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[200], // Change text color to white
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Learn With Catpawz is a big knowledge base for all my knowledge, because what good is it to just keep it to myself.. All things can be accessed for free!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                const SizedBox(height: 10),
                Text(
                  'You can either directly register an account using email/password or login with one of the following OAuth providers.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: kIsWeb
                        ? null
                        : () => _loginWithO2(context, OAuthProvider.github),
                    icon: const FaIcon(FontAwesomeIcons.github),
                    label: const Text('Login with GitHub'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: kIsWeb
                        ? null
                        : () => _loginWithO2(context, OAuthProvider.google),
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: const Text('Login with Google'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: kIsWeb
                        ? null
                        : () => _loginWithO2(context, OAuthProvider.discord),
                    icon: const FaIcon(FontAwesomeIcons.discord),
                    label: const Text('Login with Discord'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)), // Customize border radius
                    ),
                  ),
                ),
                const SizedBox(
                    height: 10), // Add some spacing between the fields
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)), // Customize border radius
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _loginWithEmail(context),
                    icon: const FaIcon(FontAwesomeIcons.user),
                    label: const Text('Login using email & password'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _RegisterWithEmail(context),
                    icon: const FaIcon(FontAwesomeIcons.plus),
                    label: const Text('Register using email & password'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
