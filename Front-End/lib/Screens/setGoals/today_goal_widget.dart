import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TodayGoalsWidget extends StatelessWidget {
  const TodayGoalsWidget({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _fetchTodayGoals() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final String uid = user.uid;
      final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .collection('setgoals')
          .doc(todayDate)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()?['todo'] as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching today's goals: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchTodayGoals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(child: Text(''));
        } else {
          final goals = snapshot.data!;
          final pendingGoals = goals.entries
              .where((entry) => entry.value.values.contains(false))
              .expand((entry) => entry.value.entries
                  .where((e) => !e.value)
                  .map((e) => MapEntry(entry.key, e.key)))
              .toList();

          return Column(children: [
            if (pendingGoals.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingGoals.length,
              itemBuilder: (context, index) {
                final time = pendingGoals[index].key;
                final goal = pendingGoals[index].value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(time),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 3.6 * screenWidth / 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(child: Text(goal)),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ],
                  ),
                );
                // return ListTile(
                //   title: Text('$time  $goal'),
                // );
              },
            ),
          ]);
        }
      },
    );
  }
}
