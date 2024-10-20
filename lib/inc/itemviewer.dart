import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ItemViewer extends StatelessWidget {
  final String title;
  final String markdownContent;

  const ItemViewer(
      {Key? key, required this.title, required this.markdownContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF141318), // Use the hex color 141318
      systemNavigationBarIconBrightness: Brightness.light, // Icon color
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: (Colors.deepPurple[100])?.withOpacity(0.1), // Adjust the opacity as needed
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // Set the status bar color to white
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // Set the status bar icons to dark
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
        HapticFeedback.vibrate();
        Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: markdownContent,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(fontSize: 16),
            code: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Colors.grey[900],
            ),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[700]!), // Light gray border
            ),
            codeblockPadding: EdgeInsets.all(8.0),
            blockquote: TextStyle(
              backgroundColor: Colors.deepPurple[900],
              color: Colors.white,
            ),
            blockquoteDecoration: BoxDecoration(
              color: Colors.deepPurple[900]?.withOpacity(1),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.deepPurple[500]!),
            ),
            h1: TextStyle(fontWeight: FontWeight.bold),
            h2: TextStyle(fontWeight: FontWeight.bold),
            h3: TextStyle(fontWeight: FontWeight.bold),
            h4: TextStyle(fontWeight: FontWeight.bold),
            h5: TextStyle(fontWeight: FontWeight.bold),
            h6: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
