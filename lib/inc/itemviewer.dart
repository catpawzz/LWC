import 'package:cedu/inc/haptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemViewer extends StatelessWidget {
  final String title, author;
  final String markdownContent;

  const ItemViewer(
      {Key? key,
      required this.title,
      required this.markdownContent,
      required this.author})
      : super(key: key);

  void _openWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF141318), // Use the hex color 141318
      systemNavigationBarIconBrightness: Brightness.light, // Icon color
    ));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Written by $author',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Markdown(
          data: markdownContent,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(fontSize: 16),
            code: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Colors.grey[900],
            ),
            a: TextStyle(
              color: Colors.deepPurple[400] ?? Colors.deepPurple, // Customize the link color here
            ),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[700]!), // Light gray border
            ),
            codeblockPadding: const EdgeInsets.all(8.0),
            blockquote: TextStyle(
              backgroundColor: Colors.deepPurple[900],
              color: Colors.white,
            ),
            blockquoteDecoration: BoxDecoration(
              color: Colors.deepPurple[900]?.withOpacity(1),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.deepPurple[500]!),
            ),
            h1: const TextStyle(fontWeight: FontWeight.bold),
            h2: const TextStyle(fontWeight: FontWeight.bold),
            h3: const TextStyle(fontWeight: FontWeight.bold),
            h4: const TextStyle(fontWeight: FontWeight.bold),
            h5: const TextStyle(fontWeight: FontWeight.bold),
            h6: const TextStyle(fontWeight: FontWeight.bold),
            horizontalRuleDecoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.deepPurple[200] ?? Colors.deepPurple,
                  width: 2.0,
                ),
              ),
            ),
          ),
          onTapLink: (text, href, title) {
            vibrateSelection();
            if (href != null) {
              _openWebsite(href);
            }
          },
          
        ),
      ),
    );
  }
}
