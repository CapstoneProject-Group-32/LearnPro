import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Screens/Profile/user_profile.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
//Profile back button

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationBarBottom(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 28,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Profile",
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

                const SizedBox(
                  height: 30,
                ),
                //.......................................

                Container(
                  width: 380,
                  height: 130,
                  decoration: ShapeDecoration(
                    color: const Color(0x190043CE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x190043CE),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: 66,
                          height: 66,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/profilepic.png"),
                              radius: 40,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chamod Requested for tutoring',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 208,
                            height: 15,
                            child: const Text(
                              'Subject: JAVA Programming',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            width: 208,
                            height: 15,
                            child: const Text(
                              'Lessson: OOP Theories',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            width: 208,
                            height: 15,
                            child: const Text(
                              'Date: 2024-06-15',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            width: 208,
                            height: 15,
                            child: const Text(
                              'Time: 14:30',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.border_color_rounded),
                          Icon(Icons.delete)
                        ],
                      ),
                    ],
                  ),
                )

                //.........................................
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key}) : super(key: key);

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final User? currentUser = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Notifications'),
//         ),
//         body: currentUser == null
//             ? const Center(child: Text('You are not logged in'))
//             : StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(currentUser!.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Something went wrong'));
//                   }

//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return const Center(child: Text('No notifications found'));
//                   }

//                   final userDoc = snapshot.data!;
//                   final receivedRequests = List<Map<String, dynamic>>.from(
//                       userDoc['receivedRequests'] ?? []);

//                   if (receivedRequests.isEmpty) {
//                     return const Center(child: Text('No notifications found'));
//                   }

//                   return ListView.builder(
//                     itemCount: receivedRequests.length,
//                     itemBuilder: (context, index) {
//                       final request = receivedRequests[index];
//                       return Card(
//                         child: ListTile(
//                           title: Text('Subject: ${request['subject']}'),
//                           subtitle: Text(
//                               'Lesson: ${request['lesson']} \nDate: ${request['date']} \nTime: ${request['time']}'),
//                           trailing: Text(
//                               'Received: ${request['timestamp'].toDate().toString()}'),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
