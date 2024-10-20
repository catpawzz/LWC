// ignore_for_file: library_private_types_in_public_api

import 'package:appwrite/appwrite.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../inc/api.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              username ?? '-',
              style: TextStyle(
                fontSize: 32,
                color: Colors.deepPurple[100],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "This is your LWC profile, here you can review and update your account information.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[200],
              ),
            ),
            const SizedBox(height: 5),
            Divider(
              color: Colors.deepPurple[300],
              thickness: 2,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
