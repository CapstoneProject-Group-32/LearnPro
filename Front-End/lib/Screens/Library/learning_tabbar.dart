import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/screen/flashcard_library_screen.dart';
import 'package:flutter_application_1/Screens/Library/flash_card_collection.dart';
import 'package:flutter_application_1/Screens/Library/libray_page.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:flutter_application_1/group/joined_group_screen.dart';

class LearningTabBar extends StatefulWidget {
  const LearningTabBar({Key? key}) : super(key: key);

  @override
  State<LearningTabBar> createState() => _LearningTabBarState();
}

class _LearningTabBarState extends State<LearningTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarBottom(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Library",
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
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              tabs: [
                _buildTab('Notes', 0),
                _buildTab('Flashcards', 1),
                _buildTab('Quizzes', 2),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LibraryPage(),
                  FlashCardCollectionScreen(),
                  Center(child: Text("Quiz feature is not available ")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int tabIndex) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
