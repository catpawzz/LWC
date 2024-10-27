import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../inc/haptic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LWC Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SetupPage(),
    );
  }
}

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int _currentStep = 0;

  final List<Step> _steps = [
    const Step(
      title: Text('Username'),
      content: Text('Content for Step 1'),
      isActive: true,
    ),
    const Step(
      title: Text('Bio'),
      content: Text('Content for Step 2'),
      isActive: true,
    ),
    const Step(
      title: Text('Information'),
      content: Text("Your profile picture is fetched using Gravatar's API, they use your email to fetch your profile picture. I am in no way affiliated with Gravatar.\n\nUsing this app means you agree to the terms of service and privacy policy."),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Finish account setup",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "It won't take long :)",
              style:
                  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        backgroundColor: (Colors.deepPurple[100])
            ?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            vibrateSelection();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: _steps,
      ),
    );
  }
}