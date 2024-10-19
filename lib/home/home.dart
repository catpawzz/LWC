import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn With Catpawz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: (Colors.deepPurple[100])
            ?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Set the status bar color to white
          statusBarIconBrightness:
              Brightness.light, // Set the status bar icons to dark
        ),
      ),
      body: Center(
        child: Text('Hello, Flutter!'),
      ),
    );
  }
}
