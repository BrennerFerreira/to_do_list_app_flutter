/// In this file, the app handle its initialization, getting the user
/// chosen main color and running the app. The splash screen added helps
/// to hide the changing color (initially blue) process and giving the
/// user a smooth start.

import 'package:flutter/material.dart';
import 'package:to_do_list/screens/home_screen/home_screen.dart';
import 'package:to_do_list/screens/splash_screen/splash_screen.dart';
import 'package:to_do_list/theme/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color newMainAppColor;
  Color mainAppColor = Colors.blue;

  ///This function recovers the user chosen main color [newMainColor] and
  ///compares it to the standard [mainColor] for the app (blue). If they are
  ///different, it changes the app [mainColor] to the [newMainColor] the user
  ///chose and uses setState to update the UI.
  Future<void> _setMainAppColor() async {
    newMainAppColor = await AppTheme.getMainAppColor();
    if (newMainAppColor == mainAppColor) {
      return;
    } else if (newMainAppColor != mainAppColor) {
      mainAppColor = newMainAppColor;
      setState(() {});
    }
  }

  /// The best way I have found to get the user preferred color was to use the
  /// [getMainColor] function within the initState so it updates the color
  /// when the app starts.
  @override
  void initState() {
    super.initState();
    _setMainAppColor();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List App',
      theme: ThemeData(
        primaryColor: mainAppColor,
      ),
      home: AppSplashScreen(
        afterSplash: HomeScreen(changeAppColor: _setMainAppColor),
      ),
    );
  }
}
