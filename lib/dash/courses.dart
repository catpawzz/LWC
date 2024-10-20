// ignore_for_file: library_private_types_in_public_api

import 'package:appwrite/appwrite.dart';
import 'package:cedu/inc/haptic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../inc/api.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Client client = ApiClient().client;
  late Account account;

  @override
  void initState() {
    super.initState();
    account = Account(client);
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
              "Courses",
              style: TextStyle(
                fontSize: 32,
                color: Colors.deepPurple[100],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Go through custom made, and free quizzes and tests to improve your coding skills.",
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
