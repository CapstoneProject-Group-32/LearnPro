import 'dart:convert';

import 'package:LearnPro/tutoring_system/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:LearnPro/Flashcards/utill/dialog_utils.dart';
import 'package:LearnPro/Models/studiedcontent.dart';
import 'package:provider/provider.dart';

import '../../tutoring_system/custom_appbar.dart';
import '../generate_flashcard.dart';
import 'flashcard_home _screen.dart';

class ContentForm extends StatefulWidget {
  const ContentForm({super.key});

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
      // print('Subject: $subject1');
      // print('Main Topic: $mainTopic1');
      // print('Data Set Map: $dataSetMap');
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
              builder: (context) =>
                  FlashcardScreen(flashcardSetId: flashcardSetID),
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
          const SnackBar(content: Text('User not signed in')),
        );
      }
    }
  }

  int get heightofabox => dataSetMap.isNotEmpty ? 300 : 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Enter Content'),
      bottomSheet: dataSetMap.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    // height: 40,
                    width: 120,
                    child: CustomButton(
                      text: 'Clear',
                      onPressed: () {
                        setState(() {
                          dataSetMap.clear();
                        });
                      },
                      backgroundColor: Colors.white38,
                    ),
                    // child: CustomButton(
                    //   text: "Cancel",
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   backgroundColor: Theme.of(context).colorScheme.background,
                    //   foregroundColor: Theme.of(context).colorScheme.secondary,
                    //   // foregroundColor: Colors.red,
                    //   borderColor: Theme.of(context).colorScheme.secondary,
                    // ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: CustomButton(
                      text: "Submit",
                      onPressed: () {
                        setState(() {
                          if (dataSetMap.isNotEmpty &&
                              _inputText4.text.isNotEmpty &&
                              _inputText3.text.isNotEmpty) {
                            mainTopic1 = _inputText4.text;
                            subject1 = _inputText3.text;
                            _submitForm();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please Fill  all the fields in the form')),
                            );
                          }
                          // Call submit form here
                        });
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      borderColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            )
          : null,
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
                      borderRadius: BorderRadius.circular(5.0),
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
                      borderRadius: BorderRadius.circular(5.0),
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
                            borderRadius: BorderRadius.circular(5.0),
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
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
                              borderRadius: BorderRadius.circular(5.0),
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: heightofabox.toDouble() /
                      1.3, // Constrained height for the list
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thickness: 6.0,
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
                                //Color.fromARGB(255, 230, 230, 230),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  color: Colors.white60,
                                ),
                                child: Center(
                                  child: Text(
                                    subtopics,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      // decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              ...listitemsofsubtopic.map((listitemsofsubtopic) {
                                return Container(
                                  height: 35,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8.0),
                                  //  color: Colors.white10,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Text('\u2022 $listitemsofsubtopic'),
                                  // child: RichText(
                                  //   text: TextSpan(
                                  //     style:
                                  //         const TextStyle(color: Colors.black),
                                  //     children: <InlineSpan>[
                                  //       const WidgetSpan(
                                  //         child: Icon(
                                  //           Icons.circle,
                                  //           size: 7.0,
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //       TextSpan(
                                  //           text: "  $listitemsofsubtopic"),
                                  //     ],
                                  //   ),
                                  // ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // CustomButton(
                //   text: 'Clear',
                //   onPressed: () {
                //     setState(() {
                //       dataSetMap.clear();
                //     });
                //   },
                //   backgroundColor: Colors.white38,
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       dataSetMap.clear();
                //     });
                //   },
                //   child: const Text("Clear"),
                // ),
                const SizedBox(height: 20),
                //   const FilePickerButton(),
                //const SizedBox(height: 50),
                dataSetMap.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 120,
                            child: CustomButton(
                              text: "Cancel",
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              // foregroundColor: Colors.red,
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 120,
                            child: CustomButton(
                              text: "Submit",
                              onPressed: () {
                                setState(() {
                                  if (dataSetMap.isNotEmpty &&
                                      _inputText4.text.isNotEmpty &&
                                      _inputText3.text.isNotEmpty) {
                                    mainTopic1 = _inputText4.text;
                                    subject1 = _inputText3.text;
                                    _submitForm();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please Fill  all the fields in the form')),
                                    );
                                  }
// Call submit form here
                                });
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
//                     Flexible(
//                       child: SizedBox(
//                         width: 150,
//                         height: 40,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 31, 231, 198),
//                           ),
//                           child: const Text(
//                             "Submit",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               if (subject1.isNotEmpty) {
//                                 mainTopic1 = _inputText4.text;
//                                 subject1 = _inputText3.text;
//                                 _submitForm();
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text(
//                                           'Please Fill  all the fields in the form')),
//                                 );
//                               }
// // Call submit form here
//                             });
//                           },
//                         ),
//                       ),
//                     ),
                          // const SizedBox(width: 20),
                          // Flexible(
                          //   child: SizedBox(
                          //     width: 150,
                          //     height: 40,
                          //     child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor:
                          //             const Color.fromARGB(255, 249, 249, 249),
                          //       ),
                          //       child: const Text(
                          //         "Cancel",
                          //         style: TextStyle(color: Colors.black),
                          //       ),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      )
                    : const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AppBar customizedAppbar() {
  //   return AppBar(
  //     title: const Row(
  //       children: [
  //         //Icon(Icons.arrow_back),
  //         SizedBox(width: 20),
  //         Flexible(
  //           child: Text(
  //             "Enter Content",
  //             style: TextStyle(fontWeight: FontWeight.w700),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
