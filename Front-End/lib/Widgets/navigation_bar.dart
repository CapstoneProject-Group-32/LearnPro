import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/timer_history_model.dart';
import 'package:flutter_application_1/Screens/Timer/timer_page.dart';
import 'package:flutter_application_1/Screens/find_studybuddies.dart';
import 'package:flutter_application_1/Screens/home_page.dart';
import 'package:flutter_application_1/Screens/learndesk_page.dart';
import 'package:flutter_application_1/Screens/library.dart';

class NavigationBarBottom extends StatefulWidget {
  const NavigationBarBottom({super.key});

  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  int myIndex = 0;
  final screens = [
    const HomePage(),
    const Library(),
    const LearnDesk(),
    const StudyBuddies(),
    const MainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        //showSelectedLabels: false,
        showUnselectedLabels: false,

        backgroundColor: Colors.white,
        selectedItemColor: Colors.lightBlue,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Library',
            // backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'LearnDesk',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Groups',
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
            //backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
