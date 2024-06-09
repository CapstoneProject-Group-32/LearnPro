import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';

class AcceptRequest extends StatefulWidget {
  final String senderUid; // The UID of the sender
  final String requestId; // The ID of the request
  const AcceptRequest(
      {required this.senderUid, required this.requestId, Key? key})
      : super(key: key);

  @override
  State<AcceptRequest> createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _zoomlinkController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authService = AuthServices();
  late String userName;
  late String profilePic;

  @override
  void initState() {
    super.initState();
    _initializeUserName();
    _initializegetProfilePicURL();
    _dateController.addListener(_updateDateText);
    _timeController.addListener(_updateTimeText);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _zoomlinkController.dispose();
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

  Future<void> _acceptRequest() async {
    final date = _dateController.text;
    final time = _timeController.text;
    final link = _zoomlinkController.text;

    if (date.isEmpty || time.isEmpty || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Add the accepted request to the sender's document
      await _firestore
          .collection('users')
          .doc(widget.senderUid)
          .collection('AcceptedRequests')
          .doc(currentUser.uid)
          .set({
        'date': date,
        'time': time,
        'link': link,
        'receiverName': userName,
        'receiverUid': currentUser.uid,
        'senderProfilePic': profilePic, // The prodilePic of the sender
      });

      // Delete the request from the receiver's receivedTuitionRequests
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('receivedTuitionRequests')
          .doc(widget.requestId)
          .delete();

      // Add the sender's UID to the receiver's tutored list
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('tutored')
          .doc(widget.senderUid)
          .set({});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted and sender notified')),
      );

      Navigator.pop(context); // Go back to the notifications page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept request: $e')),
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
                // Schedule Meeting back button
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
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 28,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Schedule Meeting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
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
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _zoomlinkController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Paste your Zoom link here",
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
                        const SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: _acceptRequest,
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
