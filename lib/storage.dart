import 'dart:convert';

import 'package:remainders/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemainderStorage {
  static const String _key = 'reminders';

  // Save reminders to SharedPreferences
  Future<void> saveReminders(List<Remainder> remainder) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        remainder.map((remainder) => jsonEncode(remainder.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Load reminders from SharedPreferences
  Future<List<Remainder>> loadReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) return []; // Return an empty list if no data found

    return jsonList
        .map((json) => Remainder.fromJson(jsonDecode(json)))
        .toList();
  }
}
