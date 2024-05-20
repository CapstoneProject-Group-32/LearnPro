import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Controllers/history_controller.dart';
import 'package:flutter_application_1/Models/timer_history_model.dart';
import 'package:flutter_application_1/Widgets/history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryController historyController;
  late List<History> listHistory;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    historyController = HistoryController();
    listHistory = [];
    _initPrefs();
    _loadHistory();
  }

  Future<void> _initPrefs() async {
    await HistoryController.init();
    prefs = HistoryController.getPrefs();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      await HistoryController.init();
      final historyStrings = prefs.getStringList("history");
      if (historyStrings != null) {
        setState(() {
          listHistory = historyStrings
              .map((jsonString) => History.fromJson(json.decode(jsonString)))
              .toList();
          listHistory.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        });
      } else {
        // Handle the case when historyStrings is null
        print("History is null");
      }
    } catch (e) {
      // Handle any exceptions that occur during the reading process
      print("Failed to load history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.blue),
          title: const Text(
            "History",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          ),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            final item = listHistory[index];
            final prevItem = index > 0 ? listHistory[index - 1] : null;
            final isNewDay = prevItem == null ||
                item.dateTime.day != prevItem.dateTime.day ||
                item.dateTime.month != prevItem.dateTime.month ||
                item.dateTime.year != prevItem.dateTime.year;
            return HistoryItem(
              history: item,
              isNewDay: isNewDay,
            );
          },
          itemCount: listHistory.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 0,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
