import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_button.dart';
import 'learning_records.dart';

class FeedbackForm extends StatefulWidget {
  final String recID;

  const FeedbackForm({super.key, required this.recID});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _feedbackController = TextEditingController();
  double _rating = 0.0;
  DocumentSnapshot? _learningRec;
  String? _currentUserId;
  DocumentSnapshot? _teacherData;
  bool _isLoading = true;
  String? _errorMessage;
  String? _feedbackError;
  DateTime reviewedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
        _learningRec = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId)
            .collection('learningRecs')
            .doc(widget.recID)
            .get();

        if (_learningRec != null) {
          String teacherId = _learningRec!['teacherId'];
          _teacherData = await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .get();
        }

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load data. Please try again later.";
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.isEmpty) {
      setState(() {
        _feedbackError = 'Feedback cannot be empty';
      });
      return;
    }

    try {
      final feedbackData = {
        'feedbackID': widget.recID,
        'feedbackMsg': _feedbackController.text,
        'lesson': _learningRec!['lesson'],
        'subject': _learningRec!['subject'],
        'stdId': _currentUserId,
        'rating': _rating,
        'date': _learningRec!['date'],
        'time': _learningRec!['time'],
        'points': _rating * 10,
        'reviewedTime': reviewedTime
      };

      final teacherId = _learningRec!['teacherId'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .collection('feedbacks')
          .doc(widget.recID)
          .set(feedbackData);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .collection('teachingRecs')
          .doc(widget.recID)
          .update({'reviewed': true});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
          .collection('learningRecs')
          .doc(widget.recID)
          .update({'reviewed': true});

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('You have given feedback')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LearningRecords(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send feedback. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Feedback Form')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Feedback Form')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_teacherData != null) ...[
                  Row(
                    children: [
                      const Text(
                        "Your Teacher:  ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(_teacherData!['profilePic']),
                        radius: 20,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _teacherData!['userName'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Meeting details:\n'
                          'Topic: ${_learningRec!['lesson']} - ${_learningRec!['subject']}\n'
                          'Time: at ${_learningRec!['time']} on ${_learningRec!['date']}'),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                    'What do you think about this session, write a feedback to your teacher'),
                const SizedBox(height: 14),
                TextField(
                  controller: _feedbackController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Feedback',
                    border: const OutlineInputBorder(),
                    errorText: _feedbackError,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Give your rating'),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 10,
                  divisions: 100,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                Center(
                    child: Text(
                  _rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "Cancel",
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      borderColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    CustomButton(
                      text: "Send Feedback",
                      onPressed: _sendFeedback,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
}
