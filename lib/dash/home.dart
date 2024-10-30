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
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
