import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../upload_pdf_page.dart';
import '../pdf_viewer_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in to view your library.'));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('usernotes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No PDFs found'));
          }

          var groupedData = <String, List<DocumentSnapshot>>{};
          for (var doc in snapshot.data!.docs) {
            var subject = doc['subject'] as String;
            if (!groupedData.containsKey(subject)) {
              groupedData[subject] = [];
            }
            groupedData[subject]!.add(doc);
          }

          return ListView(
            children: groupedData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      var doc = entry.value[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfViewerPage(
                              pdflink: doc['url'],
                            ),
                          ));
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          margin: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 11 * deviceWidth / 36,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius:
                                        const BorderRadiusDirectional.only(
                                            bottomStart: Radius.circular(10),
                                            bottomEnd: Radius.circular(10)),
                                  ),
                                  child: Text(
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    doc['title'],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'View') {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => PdfViewerPage(
                                          pdflink: doc['url'],
                                        ),
                                      ));
                                    } else if (value == 'Delete') {
                                      bool confirmDelete = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm Delete'),
                                                content: const Text(
                                                    'Do you want to delete this PDF?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;

                                      if (confirmDelete) {
                                        await FirebaseStorage.instance
                                            .refFromURL(doc['url'])
                                            .delete();
                                        await doc.reference.delete();
                                      }
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'View', 'Delete'}
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UploadPdfPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
