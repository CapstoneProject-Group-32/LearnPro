import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_appbar.dart';
import 'custom_button.dart';

class RequestTuitionForm extends StatefulWidget {
  final String userID;
  const RequestTuitionForm({required this.userID, super.key});

  @override
  _RequestTuitionFormState createState() => _RequestTuitionFormState();
}

class _RequestTuitionFormState extends State<RequestTuitionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _lessonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  DateTime sentTime = DateTime.now();
  String? _username;
  String? _profilePic;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .get();

    setState(() {
      _username = userDoc['userName'];
      _profilePic = userDoc['profilePic'];
    });
  }

  Future<void> _sendRequest() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .get();

      // final String senderStudentName = currentUserDoc['userName'];
      // final String senderStudentProfilePic = currentUserDoc['profilePic'];

      final requestDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .collection('tuitionRequests')
          .doc();

      await requestDoc.set({
        'reqid': requestDoc.id,
        'subject': _subjectController.text,
        'lesson': _lessonController.text,
        'date': _dateController.text,
        'timeStart': _startTimeController.text,
        'timeEnd': _endTimeController.text,
        'message': _messageController.text,
        'senderStudent': user.uid,
        // 'senderStudentName': senderStudentName,
        // 'senderStudentProfilePic': senderStudentProfilePic,
        'read': false,
        'status': "",
        'sentTime': sentTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You requested the meeting')),
      );

      Navigator.of(context).pop();
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a date';
    final today = DateTime.now();
    final parts = value.split('-');
    if (parts.length != 3) return 'Enter date in YYYY-MM-DD format';
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return 'Invalid date format';
    }
    if (year < today.year || year > today.year + 1) {
      return 'Year must be this year or next year';
    }
    if (month < 1 || month > 12) return 'Month must be between 1 and 12';
    if (day < 1 || day > 31) return 'Day must be between 1 and 31';
    if (year == today.year && month < today.month) {
      return 'Month must be this month or later';
    }
    if (year == today.year && month == today.month && day < today.day) {
      return 'Day must be today or later';
    }
    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a time';
    final parts = value.split(':');
    if (parts.length != 2) return 'Enter time in HH:MM format';
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) return 'Invalid time format';
    if (hours < 0 || hours > 23) return 'Invalid time';
    if (minutes < 0 || minutes > 59) return 'Inavlid time';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Request Tuition'),
      body: _username == null || _profilePic == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(_profilePic!),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Text('Teacher: $_username'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lessonController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Lesson',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a lesson';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date (YYYY-MM-DD)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        DateTextInputFormatter(),
                      ],
                      validator: _validateDate,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _startTimeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Start Time (HH:MM)',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              TimeTextInputFormatter(),
                            ],
                            validator: _validateTime,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _endTimeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'End Time (HH:MM)',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              TimeTextInputFormatter(),
                            ],
                            validator: _validateTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () => Navigator.of(context).pop(),
                        //   child: Text('Cancel'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: _sendRequest,
                        //   child: Text('Send'),
                        // ),

                        SizedBox(
                          height: 40,
                          width: 120,
                          child: CustomButton(
                            text: "Cancel",
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
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
                            text: "Send",
                            onPressed: _sendRequest,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            borderColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _lessonController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length == 4 || text.length == 7) {
      if (text.length > oldValue.text.length) {
        return TextEditingValue(
          text: '$text-',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    }
    return newValue;
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length == 2) {
      if (text.length > oldValue.text.length) {
        return TextEditingValue(
          text: '$text:',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    }
    return newValue;
  }
}
