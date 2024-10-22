import 'package:cedu/inc/haptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemViewer extends StatefulWidget {
  final String title, author;
  final String markdownContent;

  const ItemViewer(
      {Key? key,
      required this.title,
      required this.markdownContent,
      required this.author})
      : super(key: key);

  @override
  _ItemViewerState createState() => _ItemViewerState();
}

class _ItemViewerState extends State<ItemViewer> {
  final ScrollController _scrollController = ScrollController();
  final List<_HeadingItem> _headings = [];

  @override
  void initState() {
    super.initState();
    _extractHeadings();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _extractHeadings() {
    final RegExp headingRegExp = RegExp(r'^(#{1,6})\s+(.*)', multiLine: true);
    final matches = headingRegExp.allMatches(widget.markdownContent);

    _headings.clear();
    for (final match in matches) {
      final level = match.group(1)!.length;
      final text = match.group(2)!;
      _headings.add(_HeadingItem(level, text));
    }
  }

  void _scrollToHeading(String text) {
    final index = _headings.indexWhere((h) => h.text == text);
    if (index != -1) {
      final offset = _scrollController.position.minScrollExtent +
          (index * 100); // Estimate a height of 100 pixels per heading
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Written by ${widget.author}',
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu), // Icon to open the drawer
              onPressed: () {
                vibrateSelection();
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _headings.length + 1, // Add one for the divider
          itemBuilder: (context, index) {
        if (index == 1) {
          return const Divider(); // Add a divider after the first item
        }
        final headingIndex = index > 1 ? index - 1 : index;
        final heading = _headings[headingIndex];
        return ListTile(
          title: Text(
            heading.text,
            style: TextStyle(
          fontWeight: heading.level <= 2
              ? FontWeight.bold
              : FontWeight.normal,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            _scrollToHeading(heading.text);
          },
        );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Markdown(
          controller: _scrollController,
          data: widget.markdownContent,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(fontSize: 16),
            code: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Colors.grey[900],
            ),
            a: TextStyle(
              color: Colors.deepPurple[400] ?? Colors.deepPurple,
            ),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[700]!),
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

class _HeadingItem {
  final int level;
  final String text;

  _HeadingItem(this.level, this.text);
}
