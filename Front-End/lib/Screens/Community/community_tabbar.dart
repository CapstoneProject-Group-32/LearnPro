import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:LearnPro/Screens/Community/find_studybuddies.dart';
import 'package:LearnPro/Screens/Community/tutored_users_screen.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';
import 'package:LearnPro/group/joined_group_screen.dart';

class CommunityTabBar extends StatefulWidget {
  final int initialIndex;

  const CommunityTabBar({super.key, this.initialIndex = 0});

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
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
      errorMessage = null;
      userMap = null;
    });

    try {
      // Fetch all users
      QuerySnapshot searchResult = await firestore.collection('users').get();

      // Filter users based on first letter (client-side)
      List<Map<String, dynamic>> filteredUsers = searchResult.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((userData) =>
              userData['userName'] != null &&
              userData['userName']
                  .toLowerCase()
                  .startsWith(_search.text.toLowerCase()))
          .toList();

      if (filteredUsers.isNotEmpty) {
        setState(() {
          userMap = filteredUsers[0]; // Assuming you only want the first result
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "User not found";
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarBottom()),
        );
        return false; // Prevent the default back button behavior
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Community",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
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
                          suffixIcon: GestureDetector(
                            onTap: () {
                              onSearch();
                            },
                            child: const Icon(Icons.search),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs: [
                        _buildTab(
                          'People',
                          0,
                          context,
                        ),
                        _buildTab(
                          'Groups',
                          1,
                          context,
                        ),
                        _buildTab(
                          'Tutored You',
                          2,
                          context,
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
                            child: StudyBuddies(
                              userMap: userMap,
                              isLoading: isLoading,
                              errorMessage: errorMessage,
                              onSearch: onSearch,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                              bottom: 10,
                            ),
                            child: JoinedGroupsScreen(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                              bottom: 10,
                            ),
                            child: TutoredUsersScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

//Tab bar widget

Widget _buildTab(String text, int tabIndex, BuildContext context) {
  return Tab(
    child: Container(
      height: 50,
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
