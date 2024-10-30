// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../inc/api.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Client client = ApiClient().client;
  late Account account;
  String? username = 'Guest', usermail, userlast;
  String userSetupDone = "1";
  String userSpecial = "0";
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    account = Account(client);
    getUserData();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => changeNavColor());
  }

  changeNavColor() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF141318),
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> getUserData() async {
    try {
      final user = await account.get();
      setState(() {
        if (user.email.isEmpty) {
          username = 'Anonymous user';
          usermail = 'N/A';
          userlast = 'N/A';
        } else {
          username = user.name;
          usermail = user.email;
          userlast = user.accessedAt;
          nameController.text = username ?? 'Guest';
          mailController.text = usermail ?? 'Guest';
        }
      });
      final prefs = await account.getPrefs();
      setState(() {
        userSetupDone = prefs.data['setup_done'] as String;
        userSpecial = prefs.data['special'] as String;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }

  void _changeUserName(BuildContext context) async {
    vibrateSelection();
    String newUserName = nameController.text.trim();
    if (newUserName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new username')),
      );
      return;
    }
    Account account = Account(client);

    try {
      await account.updateName(name: newUserName);

      // Optionally, fetch the updated user to confirm the change
      User user = await account.get();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username changed to: ${user.name}')),
      );
    } catch (e) {
      print('Failed to change username: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change username: $e')),
      );
    }
  }

  void _sendVerificationMail(BuildContext context) async {
    vibrateSelection();
    Account account = Account(client);

    try {
      // Send a verification email to the new email address
      await account.createVerification(url: 'https://lwc.catpawz.net');

      // Optionally, fetch the updated user to confirm the change
      User user = await account.get();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent to ${user.email}! Make sure to also check your spam folder.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification: $e')),
      );
    }
  }

  void _changeUserMail(BuildContext context) async {
    vibrateSelection();
    String newUserMail = mailController.text.trim();
    if (newUserMail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new email')),
      );
      return;
    }
    Account account = Account(client);

    try {
      await account.updateEmail(email: newUserMail, password: passwordController.text);

      // Optionally, fetch the updated user to confirm the change
      User user = await account.get();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email changed to: ${user.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Add the SingleChildScrollView here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      Gravatar(usermail ?? 'guest@example.com').imageUrl(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ?? '-',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.deepPurple[100],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "This is your Learn With Catpawz profile, here you can review and update your account information.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Your profile picture within the app is loaded from the gravatar service, based on your email address.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Text(
                'Change your username',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please input your new username below and click 'Save username' to update your profile.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(12.0)), // Customize border radius
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _changeUserName(context),
                  icon: const FaIcon(FontAwesomeIcons.check),
                  label: const Text('Save username'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 5),
              Text(
                'Change your email address',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "To change your email address, please enter your new email and current password below.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mailController,
                decoration: const InputDecoration(
                  labelText: 'Mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(12.0)), // Customize border radius
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add some spacing between the fields
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
                  onPressed: () => _changeUserMail(context),
                  icon: const FaIcon(FontAwesomeIcons.check),
                  label: const Text('Save e-mail adress'),
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
                  onPressed: () => _sendVerificationMail(context),
                  icon: const FaIcon(FontAwesomeIcons.envelope),
                  label: const Text('Resend verification mail'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: (Colors.deepPurple[100])!.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 5),
              if (userSetupDone == '0')
                Card(
                  color: Colors.deepPurple[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your profile is incomplete.\nFollow the tutorial to get started.",
                          style: TextStyle(
                              fontSize: 14, color: Colors.deepPurple[50]),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/init');
                          },
                          icon: const Icon(Icons.navigate_next),
                          label: const Text('Follow tutorial'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
