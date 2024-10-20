// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, duplicate_ignore

import 'package:appwrite/appwrite.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:cedu/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dash/home.dart';
import '../inc/api.dart';

void main() {
  runApp(MaterialApp(
    home: BottomNavigation(),
  ));
}

// ignore: use_key_in_widget_constructors
class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late Account account;
  Client client = ApiClient().client;
  int _currentIndex = 0;
  String? username, usermail, userlast;
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];

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
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
    try {
      final account = Account(client);
      await account.deleteSession(sessionId: 'current');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(client: client),
        ),
      ); // Replace with your login route
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
      if (kDebugMode) {
        print('Error logging out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learn With Catpawz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome, $username',
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        backgroundColor: (Colors.deepPurple[100])
            ?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Set the status bar color to white
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Brightness.light, // Set the status bar icons to dark
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              vibrateSelection();
              if (result == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Log out',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            vibrateSelection();
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Log out'),
                          onPressed: () {
                            vibrateSelection();
                            Navigator.of(context).pop();
                            logout(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Option 1',
                child: ListTile(
                  leading: Icon(Icons.dashboard_rounded),
                  title: Text('Option 1'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: ListTile(
                  leading: Icon(Icons.collections_bookmark_rounded),
                  title: Text('Option 2'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('Log out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 60, // Set the desired height here
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          vibrateSelection();
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_rounded),
            label: 'Collections',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_rounded),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
