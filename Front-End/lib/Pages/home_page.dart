import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/find_studybuddies.dart';
import 'package:flutter_application_1/Pages/learndesk_page.dart';
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
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF74FE8A),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
// Name and Date

                            const Padding(
                              padding: EdgeInsets.only(top: 12, left: 10),
                              child: Row(
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
                      color: const Color(0xFF74FE8A),
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
                          const LearnDesk(),
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

//Today Goals subheading by calling subtopic method

                  _subtopics('Today Goals'),

//Join Groups subheading by calling subtopic method

                  _subtopics('Join Groups'),

                  const SizedBox(
                    height: 18,
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        _groupContainer(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/google.png'),
                          'Java Programming',
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        _groupContainer(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/google.png'),
                          'Java Programming',
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        _groupContainer(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/google.png'),
                          'Java Programming',
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        _groupContainer(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/google.png'),
                          'Java Programming',
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        _groupContainer(
                          context,
                          const StudyBuddies(),
                          const AssetImage('assets/google.png'),
                          'Java Programming',
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

// View Button method calling

                  _viewallButton(),

                  const SizedBox(
                    height: 20,
                  ),

//Your Freinds subheading by calling subtopic method

                  _subtopics('Your Freinds'),

                  const SizedBox(
                    height: 10,
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        _friendContainer(
                            context,
                            const StudyBuddies(),
                            const AssetImage('assets/flutterbook.png'),
                            'Chamod Gangeoda',
                            'CS Undergraduate'),
                        const SizedBox(
                          width: 25,
                        ),
                        _friendContainer(
                            context,
                            const StudyBuddies(),
                            const AssetImage('assets/flutterbook.png'),
                            'Chamod Gangeoda',
                            'CS Undergraduate'),
                        const SizedBox(
                          width: 25,
                        ),
                        _friendContainer(
                            context,
                            const StudyBuddies(),
                            const AssetImage('assets/flutterbook.png'),
                            'Chamod Gangeoda',
                            'CS Undergraduate'),
                        const SizedBox(
                          width: 25,
                        ),
                        _friendContainer(
                            context,
                            const StudyBuddies(),
                            const AssetImage('assets/flutterbook.png'),
                            'Chamod Gangeoda',
                            'CS Undergraduate'),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 27,
                  ),

// View Button method calling

                  _viewallButton(),

                  const SizedBox(
                    height: 20,
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
  return InkWell(
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
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

//Subtopic Method

Widget _subtopics(String subtopic) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtopic,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
      ],
    ),
  );
}

//Group Container Method

Widget _groupContainer(BuildContext context, Widget linkedPage,
    ImageProvider<Object> groupImage, String groupTopic) {
  return Container(
    width: 240,
    height: 250,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        Container(
          width: 240,
          height: 145,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image(
            image: groupImage,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 240,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  groupTopic,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => linkedPage,
                    ),
                  );
                },
                child: Container(
                  width: 127,
                  height: 27.56,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF7BE7FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'View',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//View All Button

Widget _viewallButton() {
  return Container(
    width: 275,
    height: 40,
    decoration: ShapeDecoration(
      color: const Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: const Center(
      child: Text(
        'View All',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

//Freind container methods

Widget _friendContainer(BuildContext context, Widget linkedPage,
    ImageProvider<Object> friendImage, String friendname, String frindLevel) {
  return Container(
    width: 200,
    height: 250,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Center(
      child: Container(
        height: 230,
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(
            10,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.values[2],
          children: [
            ClipOval(
              child: Image(
                image: friendImage,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              friendname,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              frindLevel,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => linkedPage),
                );
              },
              child: Container(
                width: 130,
                height: 28,
                decoration: ShapeDecoration(
                  color: const Color(0xFF7BE7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Request Tution',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
