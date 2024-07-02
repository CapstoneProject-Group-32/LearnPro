import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:LearnPro/tutoring_system/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SetGoals extends StatefulWidget {
  @override
  _SetGoalsState createState() => _SetGoalsState();
}

class _SetGoalsState extends State<SetGoals> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _currentMonth = '';
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  Map<String, Map<String, dynamic>> _goals = {};
  bool _isUpdated = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentMonth = DateFormat('MMMM').format(_currentDate);
    _loadGoals();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  Future<void> _loadGoals() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('setgoals')
            .doc(DateFormat('yyyy-MM-dd').format(_selectedDate))
            .get();
        if (snapshot.exists) {
          setState(() {
            _goals = Map<String, Map<String, dynamic>>.from(
                snapshot.data()?['todo'] ?? {});
          });
        } else {
          setState(() {
            _goals = {};
          });
        }
      } catch (e) {
        print('Error loading goals: $e');
      }
    }
  }

  void _scrollToToday() {
    int todayIndex = _currentDate.day - 1;
    double containerWidth = 58.0; // 50 width + 4 margin left + 4 margin right
    double scrollPosition = (todayIndex - 3) * containerWidth;
    _scrollController.animateTo(
      scrollPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showGoalDialog({String? time, String? goal, bool isEdit = false}) {
    TextEditingController timeController = TextEditingController(text: time);
    TextEditingController goalController = TextEditingController(text: goal);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Goal' : 'Add New Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: goalController,
                decoration: InputDecoration(
                  labelText: 'Goal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (timeController.text.isNotEmpty &&
                    goalController.text.isNotEmpty) {
                  setState(() {
                    _goals[timeController.text] = {
                      goalController.text: false,
                    };
                    _isUpdated = true;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGoal(String time) {
    setState(() {
      _goals.remove(time);
      _isUpdated = true;
    });
  }

  Future<void> _updateGoals() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('setgoals')
            .doc(DateFormat('yyyy-MM-dd').format(_selectedDate))
            .set({'todo': _goals});
        setState(() {
          _isUpdated = false;
        });
      } catch (e) {
        print('Error updating goals: $e');
      }
    }
  }

  Widget _buildGoalsList() {
    if (_goals.isEmpty) {
      return Center(
        child: Text("Set goals"),
      );
    }
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: _goals.keys.map((time) {
        String goal = _goals[time]!.keys.first;
        bool done = _goals[time]![goal];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              SizedBox(width: screenWidth / 8, child: Text(time)),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text(goal)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: done,
                    onChanged: (bool? value) {
                      setState(() {
                        _goals[time]![goal] = value ?? false;
                        _isUpdated = true;
                      });
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showGoalDialog(time: time, goal: goal, isEdit: true);
                      } else if (value == 'delete') {
                        _deleteGoal(time);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayContainers() {
    int daysInMonth =
        DateUtils.getDaysInMonth(_currentDate.year, _currentDate.month);
    int today = _currentDate.day;

    return Container(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          DateTime date =
              DateTime(_currentDate.year, _currentDate.month, index + 1);
          bool isToday = date.day == today;
          bool isSelected = date.day == _selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _loadGoals();
              });
            },
            child: Container(
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(),
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Set goals"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Calendar',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text(_currentMonth, style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 10),
            _buildDayContainers(),
            Expanded(child: _buildGoalsList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "Add New",
                  onPressed: () => _showGoalDialog(),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  borderColor: Theme.of(context).colorScheme.secondary,
                ),
                if (_isUpdated)
                  CustomButton(
                    text: "Update",
                    onPressed: _updateGoals,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
