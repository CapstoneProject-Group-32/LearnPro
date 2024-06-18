import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/history_controller.dart';
import 'package:flutter_application_1/models/timer_history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/utils/util_functions.dart'; // Import the utility file

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> listHistory = [];
  int sumOfFocusTimeInSeconds = 0;
  HistoryController historyController = HistoryController();
  User? user = FirebaseAuth.instance.currentUser; // Get the current user
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      if (user != null) {
        listHistory = await historyController.readFocusTime(user!.uid);
        sumOfFocusTimeInSeconds =
            await historyController.readSumOfFocusTime(user!.uid);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Focus History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Focus Time: ${formatDuration(sumOfFocusTimeInSeconds)}', // Display the correctly formatted total focus time
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Focus Duration: ${formatDuration(listHistory[index].focusedSecs)}'),
                            subtitle: Text(
                                'Date: ${listHistory[index].dateTime.toLocal().toString().split(' ')[0]}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
