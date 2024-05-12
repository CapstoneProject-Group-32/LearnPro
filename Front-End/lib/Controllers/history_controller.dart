import 'dart:convert';

import 'package:flutter_application_1/models/timer_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getPrefs() {
    if (_prefs == null) {
      throw Exception("SharedPreferences has not been initialized.");
    }
    return _prefs!;
  }

  List<String>? list = [];
  List<History>? historyList = [];

  read(String key) {
    try {
      historyList!.clear();
      list!.clear();
      list!.addAll(getPrefs().getStringList(key)!);
      for (var item in list!) {
        historyList!.add(History.fromJson(json.decode(item)));
      }
    } catch (_) {
      // Handle the exception, e.g., log it or show a message to the user.
    }

    return historyList;
  }

  save(String key, List<History> historyList) async {
    list!.clear();
    for (var item in historyList) {
      list!.add(json.encode(item.toJson()));
    }
    getPrefs().setStringList(key, list!);
  }
}
