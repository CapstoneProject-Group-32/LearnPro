import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';

class RequestTuitionScreen extends StatefulWidget {
  final String friendUid; // The UID of the friend you're sending the request to
  const RequestTuitionScreen({required this.friendUid, Key? key})
      : super(key: key);

  @override
  State<RequestTuitionScreen> createState() => _RequestTuitionScreenState();
}

class _RequestTuitionScreenState extends State<RequestTuitionScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final authService = AuthServices();
  late String userName; // Declare userName as a class field
  late String profilePic;

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _lessonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserName(); // Call the method to fetch the user's name
    _initializegetProfilePicURL();
    _dateController.addListener(_updateDateText);
    _timeController.addListener(_updateTimeText);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _subjectController.dispose();
    _lessonController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserName() async {
    userName = (await authService
        .getCurrentUserName())!; // Fetch the current user's name
  }

  Future<void> _initializegetProfilePicURL() async {
    profilePic = (await authService.getProfilePicURL(
        currentUser.uid))!; // Fetch the current user's profilePic
  }

  void _updateDateText() {
    final text = _dateController.text;
    if (text.length == 4 || text.length == 7) {
      if (text.length == 4 && !text.endsWith('-')) {
        _dateController.text = '$text-';
      } else if (text.length == 7 && !text.endsWith('-')) {
        _dateController.text = '$text-';
      }
      _dateController.selection = TextSelection.fromPosition(
        TextPosition(offset: _dateController.text.length),
      );
    }
  }

  void _updateTimeText() {
    final text = _timeController.text;
    if (text.length == 2) {
      if (!text.endsWith(':')) {
        _timeController.text = '$text:';
      }
      _timeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _timeController.text.length),
      );
    }
  }

  Future<void> _sendTuitionRequest() async {
    final subject = _subjectController.text;
    final lesson = _lessonController.text;
    final date = _dateController.text;
    final time = _timeController.text;

    // Validate that all fields are filled
    if (subject.isEmpty || lesson.isEmpty || date.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Create the request data
    final request = {
      'subject': subject,
      'lesson': lesson,
      'date': date,
      'time': time,
      'sender': _auth.currentUser!.uid, // The UID of the sender
      'senderName': userName, // The name of the sender
      'senderProfilePic': profilePic, // The prodilePic of the sender
    };

    try {
      // Add the request to the receiver's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendUid)
          .collection('receivedTuitionRequests')
          .doc(_auth.currentUser!.uid)
          .set(request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully')),
      );
      Navigator.pop(context); // Go back to the findstudybuddy page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.arrow_back_ios_new_rounded,
                            size: 28, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Request Tuition",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _subjectController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Subject",
                            labelStyle: const TextStyle(
                                color: Color(0xFF16697A),
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF16697A), width: 2)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _lessonController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Lesson or Theory",
                            labelStyle: const TextStyle(
                                color: Color(0xFF16697A),
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF16697A), width: 2)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "Mention an available time period to arrange a meeting with your study buddy.",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: "Date",
                            labelStyle: const TextStyle(
                                color: Color(0xFF16697A),
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF16697A), width: 2)),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|-'))
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _timeController,
                          decoration: InputDecoration(
                            labelText: "Time",
                            labelStyle: const TextStyle(
                                color: Color(0xFF16697A),
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                            hintText: 'HH:MM',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF16697A), width: 2)),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|:'))
                          ],
                        ),
                        const SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: _sendTuitionRequest,
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF29F6D2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadows: const [
                                      BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text('Send',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Work Sans',
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadows: const [
                                      BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Work Sans',
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
