import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/utill/dialog_utils.dart';
import 'package:flutter_application_1/Models/studiedcontent.dart';
import 'package:flutter_application_1/Widgets/myuploadbutton.dart';
import 'package:provider/provider.dart';

import '../generate_flashcard.dart';
import 'flashcard_home _screen.dart';

class ContentForm extends StatefulWidget {
  @override
  State<ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, List<String>> dataSetMap = {};
  final TextEditingController _inputText1 = TextEditingController();
  final TextEditingController _inputText2 = TextEditingController();
  final TextEditingController _inputText3 = TextEditingController();
  final TextEditingController _inputText4 = TextEditingController();
  String temp = '';
  String subject1 = '';
  String mainTopic1 = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Studiedcontent studiedcontent = Studiedcontent(
        subject1: subject1,
        mainTopic1: mainTopic1,
        dataSetMap: dataSetMap,
      );
      print('Subject: $subject1');
      print('Main Topic: $mainTopic1');
      print('Data Set Map: $dataSetMap');
      // Here you can store the studiedcontent object as needed.
      String jsonString = jsonEncode(dataSetMap);
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        try {
          showLoadingDialog(context);

          final flashcards =
              await Provider.of<GenerateFlashcard>(context, listen: false)
                  .createFlashcard(uid, subject1, mainTopic1, jsonString);

          hideLoadingDialog(context);

          final flashcardSetID =
              Provider.of<GenerateFlashcard>(context, listen: false)
                  .flashcardSetId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlashcardScreen(
                  flashcards: flashcards, flashcardSetId: flashcardSetID),
            ),
          );
        } catch (e) {
          hideLoadingDialog(context);
          print('Error creating flashcards: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to create flashcards, Try again!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not signed in')),
        );
      }
    }
  }

  int get heightofabox => dataSetMap.isNotEmpty ? 300 : 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customizedAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _inputText3,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelText: "Subject",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _inputText4,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelText: "Main topic",
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text("Enter outline structure here!!"),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputText1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          labelText: "Sub Topics",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_inputText1.text.isNotEmpty) {
                            dataSetMap[_inputText1.text] = [];
                            temp = _inputText1.text;
                            _inputText1.clear();
                          }
                        });
                      },
                      child: const Icon(Icons.add_circle_outline_outlined),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          controller: _inputText2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: "Add points under subtopic",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_inputText2.text.isNotEmpty) {
                            if (dataSetMap.containsKey(temp)) {
                              dataSetMap[temp]!.add(_inputText2.text);
                            } else {
                              dataSetMap[temp] = [_inputText2.text];
                            }
                            _inputText2.clear();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.add_circle_outline_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: heightofabox
                      .toDouble(), // Constrained height for the list
                  child: ListView.builder(
                    itemCount: dataSetMap.keys.length,
                    itemBuilder: (context, index) {
                      String subtopics = dataSetMap.keys.elementAt(index);
                      List<String> listitemsofsubtopic =
                          dataSetMap[subtopics] ?? [];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              color: const Color.fromARGB(255, 230, 230, 230),
                              child: Center(
                                child: Text(
                                  subtopics,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            ...listitemsofsubtopic.map((listitemsofsubtopic) {
                              return Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black),
                                    children: <InlineSpan>[
                                      const WidgetSpan(
                                        child: Icon(Icons.circle, size: 16.0),
                                      ),
                                      TextSpan(text: "  $listitemsofsubtopic"),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dataSetMap.clear();
                    });
                  },
                  child: const Text("Clear"),
                ),
                const SizedBox(height: 30),
                FilePickerButton(),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 31, 231, 198),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              mainTopic1 = _inputText4.text;
                              subject1 = _inputText3.text;
                              if (subject1.isEmpty ||
                                  mainTopic1.isEmpty ||
                                  dataSetMap.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please Enter the content you studied!')),
                                );
                              } else {
                                _submitForm();
                              }
                              // Call submit form here
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 249, 249, 249),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar customizedAppbar() {
    return AppBar(
      title: const Row(
        children: [
          //Icon(Icons.arrow_back),
          SizedBox(width: 20),
          Flexible(
            child: Text(
              "Enter Content",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
