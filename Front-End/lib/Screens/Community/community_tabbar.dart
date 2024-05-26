// import 'package:flutter/material.dart';

// class CommunityTabBar extends StatefulWidget {
//   const CommunityTabBar({super.key});

//   @override
//   State<CommunityTabBar> createState() => _CommunityTabBarState();
// }

// class _CommunityTabBarState extends State<CommunityTabBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: DefaultTabController(
//         length: 3,
//         child: Column(
//           children: [
//             Material(
//               child: Container(
//                 height: 100,
//                 color: Colors.white,
//                 child: TabBar(
//                   physics: const ClampingScrollPhysics(),
//                   padding: const EdgeInsets.all(10),
//                   unselectedLabelColor: Colors.black,
//                   indicatorSize: TabBarIndicatorSize.label,
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: const Color(0xFF74FE8A),
//                   ),
//                   tabs: [
//                     Tab(
//                       child: Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           color: const Color(0xFFD9D9D9),
//                         ),
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Text("People"),
//                         ),
//                       ),
//                     ),
//                     Tab(
//                       child: Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: const Color(0xFFD9D9D9)),
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Text("Group"),
//                         ),
//                       ),
//                     ),
//                     Tab(
//                       child: Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: const Color(0xFFD9D9D9)),
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Text("Tutored You"),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CommunityTabBar extends StatefulWidget {
//   const CommunityTabBar({super.key});

//   @override
//   State<CommunityTabBar> createState() => _CommunityTabBarState();
// }

// class _CommunityTabBarState extends State<CommunityTabBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: DefaultTabController(
//         length: 3,
//         child: Column(
//           children: [
//             Material(
//               child: Container(
//                 height: 100,
//                 color: Colors.white,
//                 child: TabBar(
//                   physics: const ClampingScrollPhysics(),
//                   padding: const EdgeInsets.all(10),
//                   unselectedLabelColor: Colors.black,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: const Color(0xFF74FE8A),
//                   ),
//                   tabs: [
//                     _buildTab("People"),
//                     _buildTab("Group"),
//                     _buildTab("Tutored You"),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   Center(child: Text('People Content')),
//                   Center(child: Text('Group Content')),
//                   Center(child: Text('Tutored You Content')),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTab(String text) {
//     return Tab(
//       child: Container(
//         height: 50,
//         child: Align(
//           alignment: Alignment.center,
//           child: Text(text),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CommunityTabBar extends StatefulWidget {
  const CommunityTabBar({super.key});

  @override
  State<CommunityTabBar> createState() => _CommunityTabBarState();
}

class _CommunityTabBarState extends State<CommunityTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Refresh to update the tab sizes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Material(
              child: Container(
                height: 100,
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF74FE8A),
                  ),
                  tabs: [
                    _buildTab("People", 0),
                    _buildTab("Group", 1),
                    _buildTab("Tutored You", 2),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: Text('People Content')),
                  Center(child: Text('Group Content')),
                  Center(child: Text('Tutored You Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: isSelected ? 50 : 40, // Increase height if selected
        child: Align(
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }
}
