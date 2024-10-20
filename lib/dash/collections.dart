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
  final int collectionCount =
      10; // Adjust this number based on your expected number of collections
  final String databaseId =
      '670bfd1e002d952eb58c'; // Replace with your actual database ID

  @override
  void initState() {
    super.initState();
    client =
        ApiClient().client; // Ensure that the client is initialized correctly
    databases = Databases(client);
    _fetchCollectionsAndDocuments();
  }

  Future<void> _fetchCollectionsAndDocuments() async {
    List<Map<String, dynamic>> tempCollectionsData = [];

    for (int i = 1; i <= collectionCount; i++) {
      try {
        // Fetch documents for each collection
        final documents = await databases.listDocuments(
          databaseId: databaseId,
          collectionId: i
              .toString(), // Assuming collection IDs are strings of numbers like '1', '2', etc.
        );

        // Store the collection name and its documents
        // Here, we are just using the collection ID as the name,
        // adjust if you have a way to fetch real names
        tempCollectionsData.add({
          'collectionName':
              'Collection $i', // You can customize this if you have actual names
          'documents': documents.documents,
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching documents for collection $i: $e');
        }
      }
    }

    // Update the state with the fetched data
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
              final documents = collection['documents'] as List<models.Document>;
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
              final collectionTitle = collectionTitleDoc.data['title'] ?? 'Collection';

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (bool expanded) {
                          vibrateSelection();
                        },
                        title: Text(collectionTitle), // Use the title of the hidden document
                        children: documents
                            .where((doc) => !(doc.data['is_collection_title'] ?? false))
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Difficulty: '),
                                        ...List.generate(5, (dotIndex) {
                                          return Icon(
                                            Icons.circle,
                                            color: dotIndex < data['difficulty']
                                                ? Colors.deepPurple
                                                : Colors.grey,
                                            size: 12.0,
                                          );
                                        }),
                                      ],
                                    ),
                                    Text(data['description']),
                                    const SizedBox(height: 10.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                      onPressed: () {
                                        vibrateSelection();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ItemViewer(
                                              title: data['title'],
                                              markdownContent: data['content'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.description_rounded),
                                      label: const Text('Open document'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(), // Add a divider after each ListTile
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
