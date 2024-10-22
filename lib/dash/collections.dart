import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../inc/api.dart';
import '../inc/haptic.dart';
import '../inc/itemviewer.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Client client;
  late Databases databases;
  List<Map<String, dynamic>> collectionsData = [];
  int collectionCount = 100;
  final String databaseId = '670bfd1e002d952eb58c'; 

  @override
  void initState() {
    super.initState();
    client = ApiClient().client;
    databases = Databases(client);
    _fetchCollectionFlags();
    _fetchCollectionsAndDocuments();
  }

  Future<void> _fetchCollectionFlags() async {
    try {
      final document = await databases.getDocument(
        databaseId: "6717455f0012149ec55f",
        collectionId: "normal",
        documentId: "671745b600111b41a429",
      );
      final int collections = document.data['collections'] ?? ''; 
      setState(() {
        collectionCount = collections;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching document: $e');
      }
    }
  }

  Future<void> _fetchCollectionsAndDocuments() async {
    List<Map<String, dynamic>> tempCollectionsData = [];

    for (int i = 1; i <= collectionCount; i++) {
      try {
        final documents = await databases.listDocuments(
          databaseId: databaseId,
          collectionId: i.toString(),
        );
        tempCollectionsData.add({
          'collectionName':'Collection $i',
          'documents': documents.documents,
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching documents for collection $i: $e');
        }
      }
    }
    setState(() {
      collectionsData = tempCollectionsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: collectionsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: collectionsData.length,
              itemBuilder: (context, index) {
                final collection = collectionsData[index];
                final documents =
                    collection['documents'] as List<models.Document>;
                final collectionTitleDoc = documents.firstWhere(
                  (doc) => doc.data['is_collection_title'] ?? false,
                  orElse: () => models.Document(
                    $id: '',
                    $collectionId: '',
                    $databaseId: '',
                    $createdAt: '',
                    $updatedAt: '',
                    $permissions: [],
                    data: {},
                  ),
                );
                final collectionTitle =
                    collectionTitleDoc.data['title'] ?? 'Collection';

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          backgroundColor: Colors.deepPurple[200]
                              ?.withOpacity(0.1), // Set the background color
                          onExpansionChanged: (bool expanded) {
                            vibrateSelection();
                          },
                          title: Text(
                              collectionTitle), // Use the title of the hidden document
                          children: documents
                              .where((doc) =>
                                  !(doc.data['is_collection_title'] ?? false))
                              .map((doc) {
                            var data = doc.data;
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    data['title'],
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Difficulty: '),
                                          ...List.generate(5, (dotIndex) {
                                            return Icon(
                                              Icons.circle,
                                              color:
                                                  dotIndex < data['difficulty']
                                                      ? Colors.deepPurple[300]
                                                      : Colors.grey[800],
                                              size: 12.0,
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(data['description']),
                                    ],
                                  ),
                                  onTap: () {
                                    vibrateSelection();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemViewer(
                                          title: data['title'],
                                          author: data['author'] ??
                                              "Unknown Author",
                                          markdownContent: data['content'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
