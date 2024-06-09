import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/Community/find_studybuddies.dart';

import 'package:flutter_application_1/Screens/learndesk_page.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:flutter_application_1/group/joined_group_screen.dart';

class CommunityTabBar extends StatefulWidget {
  const CommunityTabBar({super.key});

  @override
  State<CommunityTabBar> createState() => _CommunityTabBarState();
}

class _CommunityTabBarState extends State<CommunityTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
      errorMessage = null;
      userMap = null;
    });
    try {
      QuerySnapshot searchResult = await firestore
          .collection('users')
          .where("userName", isEqualTo: _search.text)
          .get();

      if (searchResult.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            searchResult.docs[0].data() as Map<String, dynamic>;
        setState(() {
          userMap = userData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Invalid user";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error searching user: $e";
        isLoading = false;
      });
    }
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
                  builder: (context) => const NavigationBarBottom(),
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
                  "Student Community",
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
        body: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: GestureDetector(
                          onTap: () {
                            onSearch();
                          },
                          child: const Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00FF00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tabs: [
                      _buildTab(
                        'People',
                        0,
                      ),
                      _buildTab(
                        'Groups',
                        1,
                      ),
                      _buildTab(
                        'Tutored You',
                        2,
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Container(
                            child: StudyBuddies(
                              userMap: userMap,
                              isLoading: isLoading,
                              errorMessage: errorMessage,
                              onSearch: onSearch,
                            ),
                          ),
                        ),
                        const JoinedGroupsScreen(),
                        const Center(
                          child: Text("Still developing"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

//Tab bar widget

Widget _buildTab(String text, int tabIndex) {
  return Tab(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        // color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
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
