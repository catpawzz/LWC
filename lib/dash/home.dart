// ignore_for_file: library_private_types_in_public_api

import 'package:appwrite/appwrite.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../inc/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Client client = ApiClient().client;
  late Account account;
  String? username, usermail, userlast;
  String userSetupDone = "1";
  String userSpecial = "0";

  @override
  void initState() {
    super.initState();
    account = Account(client);
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final user = await account.get();
      setState(() {
        username = user.name;
        usermail = user.email;
        userlast = user.accessedAt;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 32,
                color: Colors.deepPurple[100],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Welcome to your dashboard. Here you'll find an overview of your account and the latest updates, plus some random courses to get you started.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[200],
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: userSetupDone != "1",
              child: GestureDetector(
              onTap: () {
                vibrateSelection();
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.deepPurple[100],
                      size: 24.0,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Complete setup',
                      style: TextStyle(
                      color: Colors.deepPurple[100],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete your LWC profile setup, by clicking this card! It will only take a few minutes.',
                    style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[200],
                    ),
                  ),
                  ],
                ),
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
