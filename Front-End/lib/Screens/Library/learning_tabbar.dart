import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Library/flash_card_collection.dart';
import 'package:flutter_application_1/Screens/Library/libray_page.dart';

class LearningTabBar extends StatefulWidget {
  final int initialIndex;

  const LearningTabBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<LearningTabBar> createState() => _LearningTabBarState();
}

class _LearningTabBarState extends State<LearningTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
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
          title: const Text(
            "Library",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
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
                children: const [
                  LibraryPage(),
                  FlashCardCollectionScreen(),
                  Center(
                    child: Text("Quiz feature is not available"),
                  ),
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            )),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
