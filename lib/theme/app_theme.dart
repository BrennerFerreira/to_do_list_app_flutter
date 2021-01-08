import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Uses [SharedPreferences] plugin to save and read user chosen settings.
///It handles primary color and alert preferences changes.
class AppTheme {
  ///Retrieves the primary color saved. If the user did not make any changes
  ///yet, the primary color will be blue.
  static Future<Color> getMainAppColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int mainAppColorValue =
        prefs.getInt('mainColor') ?? Colors.blue.value;
    final Color mainAppColor = Color(mainAppColorValue);
    return mainAppColor;
  }

  ///When the user changes their preferences, this fucntion receives the chosen
  ///[newColor] and saves it in their device.
  static Future<void> setMainAppColor(Color newColor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int newColorValue = newColor.value;
    await prefs.setInt('mainColor', newColorValue);
  }

  ///Retrieves the user preference to show or not a warning when deleting a single
  ///[Task]. Initially, it is set to true.
  static Future<bool> getDeleteWarning() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool deleteWarning = prefs.getBool('deleteWarning') ?? true;
    return deleteWarning;
  }

  ///When the user changes their preferences to whether show or not a warning
  ///when deleting a single [Task], this function receives the [newValue] and
  ///saves it in the user device.
  static Future<void> setDeleteWarning({bool newValue}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deleteWarning', newValue);
  }

  ///Retrieves the user preference to show or not a warning when deleting all
  ///[Task] marked as done. Initially, it is set to true.
  static Future<bool> getDeleteAllWarning() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool deleteAllWarning = prefs.getBool('deleteAllWarning') ?? true;
    return deleteAllWarning;
  }

  ///When the user changes their preferences to whether show or not a warning
  ///when deleting all [Task] marked as done, this function receives the
  ///[newValue] and saves it in the user device.
  static Future<void> setDeleteAllWarning({bool newValue}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deleteAllWarning', newValue);
  }
}
