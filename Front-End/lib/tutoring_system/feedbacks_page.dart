import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedbacksPage extends StatefulWidget {
  final String userId;

  const FeedbacksPage({super.key, required this.userId});

  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  late Future<List<Map<String, dynamic>>> feedbacksFuture;
  String? teacherProfilePic;
  String? teacherUserName;

  @override
  void initState() {
    super.initState();
    feedbacksFuture = fetchFeedbacks();
    fetchTeacherProfilePic();
  }

  Future<void> fetchTeacherProfilePic() async {
    DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      teacherProfilePic = teacherDoc['profilePic'];
      teacherUserName = teacherDoc['userName'];
    });
  }

  Future<List<Map<String, dynamic>>> fetchFeedbacks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('feedbacks')
          .orderBy('reviewedTime', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw 'no-reviews';
      }

      List<Map<String, dynamic>> feedbacks = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> feedback = doc.data() as Map<String, dynamic>;
        String stdId = feedback['stdId'];
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(stdId)
            .get();
        feedback['stdUserName'] = studentDoc['userName'];
        feedback['stdPfp'] = studentDoc['profilePic'];
        feedbacks.add(feedback);
      }
      return feedbacks;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw 'no-internet';
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  double calculateAverageRating(List<Map<String, dynamic>> feedbacks) {
    double sum = feedbacks.fold(0, (sum, item) => sum + item['rating']);
    return sum / feedbacks.length;
  }

  String timeDifference(Timestamp reviewedTime) {
    DateTime now = DateTime.now();
    DateTime reviewedDateTime = reviewedTime.toDate();
    Duration diff = now.difference(reviewedDateTime);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}M ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Feedbacks'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: feedbacksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  //    SpinKitCircle(color: Colors.blue)
                  CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            String errorMessage;
            if (snapshot.error == 'no-reviews') {
              errorMessage = 'No reviews';
            } else if (snapshot.error == 'no-internet') {
              errorMessage = 'Connect to internet';
            } else {
              errorMessage = 'An error occurred';
            }
            return Center(child: Text(errorMessage));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews'));
          }

          final feedbacks = snapshot.data!;
          final averageRating = calculateAverageRating(feedbacks);
          final roundedAverage = averageRating.toStringAsFixed(1);
          final feedbackCount = feedbacks.length;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (teacherProfilePic != null)
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(teacherProfilePic!),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        teacherUserName!,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 10),
                      const Text('Overall Ratings',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text('$roundedAverage ★',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Based on $feedbackCount reviews'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbacks[index];
                      return FeedbackCard(feedback: feedback);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final profilePicture = feedback['stdPfp'];
    final name = feedback['stdUserName'];
    final rating = feedback['rating'];
    final reviewedTime = feedback['reviewedTime'] as Timestamp;
    final timeDifferenceStr = timeDifference(reviewedTime);
    final subject = feedback['subject'];
    final lesson = feedback['lesson'];
    final date = feedback['date'];
    final time = feedback['time'];
    final feedbackMsg = feedback['feedbackMsg'];
    final ratingRounded = rating.toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile main picture
                // Container(
                //   height: 100,
                //   width: 100,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(50),
                //     image: DecorationImage(
                //       image: NetworkImage(),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(profilePicture),
                ),

                // User name and rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        // fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Rated: $ratingRounded",
                          style: const TextStyle(
                            //   fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.black),
                      ],
                    ),
                  ],
                ),
                Text(timeDifferenceStr),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Attended Session:",
              style: TextStyle(
                //  fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Session container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.book, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "$lesson - $subject",
                        style: const TextStyle(
                            // fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "At $time on $date",
                        style: const TextStyle(
                            //   fontSize: 14,
                            //  color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Feedback:",
              style: TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Feedback display container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Text(
                feedbackMsg,
                style: const TextStyle(
                    //  fontSize: 14,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeDifference(Timestamp reviewedTime) {
    DateTime now = DateTime.now();
    DateTime reviewedDateTime = reviewedTime.toDate();
    Duration diff = now.difference(reviewedDateTime);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}M ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
