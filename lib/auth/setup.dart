import 'package:flutter/material.dart';

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

  List<Step> _steps = [
    Step(
      title: Text('Step 1'),
      content: Text('Content for Step 1'),
      isActive: true,
    ),
    Step(
      title: Text('Step 2'),
      content: Text('Content for Step 2'),
      isActive: true,
    ),
    Step(
      title: Text('Step 3'),
      content: Text('Content for Step 3'),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Page'),
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