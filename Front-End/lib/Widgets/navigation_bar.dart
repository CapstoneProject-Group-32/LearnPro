// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/Community/community_tabbar.dart';

// import 'package:flutter_application_1/Screens/Library/learning_tabbar.dart';
// import 'package:flutter_application_1/Screens/home_page.dart';
// import 'package:flutter_application_1/Screens/learndesk_page.dart';
// import 'package:flutter_application_1/Screens/Profile/user_profile.dart';

// class NavigationBarBottom extends StatefulWidget {
//   const NavigationBarBottom({super.key});

//   @override
//   State<NavigationBarBottom> createState() => _NavigationBarBottomState();
// }

// class _NavigationBarBottomState extends State<NavigationBarBottom> {
//   int _selectedIndex = 0;

//   void _navigateBottomBar(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<Widget> _screens = [
//     const HomePage(),
//     const LearningTabBar(),
//     const LearnDesk(),
//     const CommunityTabBar(),
//     const UserProfile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         showUnselectedLabels: false,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         selectedItemColor: Theme.of(context).colorScheme.secondary,
//         iconSize: 28,
//         type: BottomNavigationBarType.fixed,
//         onTap: _navigateBottomBar,
//         currentIndex: _selectedIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.newspaper),
//             label: 'Library',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.abc),
//             label: 'LearnDesk',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group_outlined),
//             label: 'Groups',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle_outlined),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Community/community_tabbar.dart';
import 'package:flutter_application_1/Screens/Library/learning_tabbar.dart';
import 'package:flutter_application_1/Screens/home_page.dart';
import 'package:flutter_application_1/Screens/learndesk_page.dart';
import 'package:flutter_application_1/Screens/Profile/user_profile.dart';

class NavigationBarBottom extends StatefulWidget {
  final int initialIndex;
  final int? learningTabBarIndex;
  final int? communityTabBarIndex;

  const NavigationBarBottom(
      {Key? key,
      this.initialIndex = 0,
      this.learningTabBarIndex,
      this.communityTabBarIndex})
      : super(key: key);

  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  late int _selectedIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _screens = [
      const HomePage(),
      LearningTabBar(initialIndex: widget.learningTabBarIndex ?? 0),
      const LearnDesk(),
      CommunityTabBar(initialIndex: widget.learningTabBarIndex ?? 0),
      const UserProfile(),
    ];
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // final List<Widget> _screens = [
  //   const HomePage(),
  //   LearningTabBar(initialIndex: widget.learningTabBarIndex ?? 0),
  //   const LearnDesk(),
  //   const CommunityTabBar(),
  //   const UserProfile(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        onTap: _navigateBottomBar,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'LearnDesk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
