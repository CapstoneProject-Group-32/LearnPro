import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/find_studybuddies.dart';
import 'package:flutter_application_1/Pages/focus_to_studies.dart';
import 'package:flutter_application_1/Pages/library.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  // First container

                  Container(
                    height: 275,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFAFDBE3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Name and Date

                            const Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi, Chamod",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "April 28, 2024",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: 200,
                                ),

                                //Notification

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.notifications,
                                        size: 30, color: Colors.black),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            // Today progress container

                            Container(
                              height: 150,
                              width: 350,
                              decoration: BoxDecoration(
                                color: const Color(0xFF82C0CC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Today Progress",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 58,
                                          width: 110,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF82C0CC),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text(
                                                "4h",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Focus Time",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xFF6F7665)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 58,
                                          width: 110,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF82C0CC),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text(
                                                "300",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Points",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xFF6F7665)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 58,
                                          width: 110,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF82C0CC),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text(
                                                "3",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Tutored",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xFF6F7665)),
                                              ),
                                            ],
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

                  const SizedBox(
                    height: 10,
                  ),

                  // Search bar(design only)

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Daily moto

                  Container(
                    height: 250,
                    width: 350,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAFDBE3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "\"The journey of a \n thousand miles \n begins with a single \n step. Take that step,\n keep studying,and \n you'll eventually \n reach your \n destination.\"",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/boy.png",
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Icons

                  Container(
                    width: 400,
                    height: 125,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        _iconMethod(
                          context,
                          const Library(),
                          const AssetImage('assets/task.png'),
                          'Your Notes',
                        ),
                        _iconMethod(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/cooperation.png'),
                          'Request Tutoring',
                        ),
                        _iconMethod(
                          context,
                          const FocusToStudies(),
                          const AssetImage('assets/reading.png'),
                          'Focus',
                        ),
                        _iconMethod(
                          context,
                          const Library(),
                          const AssetImage('assets/notebook.png'),
                          'Study Plan',
                        ),
                      ],
                    ),
                  ),

                  //Today Goals heading Text

                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today Goals",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Icon Method

Widget _iconMethod(BuildContext context, Widget linkedPage,
    ImageProvider<Object> iconImage, String imageTopic) {
  return Container(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => linkedPage,
          ),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image(
              image: iconImage,
              height: 50,
              width: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              imageTopic,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    ),
  );
}
