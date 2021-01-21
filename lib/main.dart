/// In this file, the app handle its initialization, getting the user
/// chosen main color and running the app. The splash screen added helps
/// to hide the changing color (initially blue) process and giving the
/// user a smooth start.

import 'package:flutter/material.dart';
import 'package:to_do_list/screens/home_screen/home_screen.dart';
import 'package:to_do_list/screens/splash_screen/splash_screen.dart';
import 'package:to_do_list/settings/app_settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color newMainAppColor;
  Color mainAppColor = Colors.blue;
  ThemeMode newAppTheme;
  ThemeMode appTheme = ThemeMode.system;

  ///This function recovers the user chosen main color [newMainColor] and
  ///compares it to the standard [mainColor] for the app (blue). If they are
  ///different, it changes the app [mainColor] to the [newMainColor] the user
  ///chose and uses setState to update the UI. The [SplashScreen] will be
  ///shown until this function returns.
  Future<Widget> _setMainAppTheme() async {
    newMainAppColor = await AppSettings.getMainAppColor();

    final String theme = await AppSettings.getAppTheme();
    switch (theme) {
      case 'light':
        newAppTheme = ThemeMode.light;
        break;
      case 'dark':
        newAppTheme = ThemeMode.dark;
        break;
      case 'automatic':
      default:
        newAppTheme = ThemeMode.system;
    }
    if (newMainAppColor != mainAppColor) {
      mainAppColor = newMainAppColor;
    }
    if (newAppTheme != appTheme) {
      appTheme = newAppTheme;
    }

    setState(() {});

    return HomeScreen(changeAppTheme: _setMainAppTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List App',
      theme: ThemeData(
        primaryColor: mainAppColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: mainAppColor,
        brightness: Brightness.dark,
      ),
      themeMode: appTheme,
      home: AppSplashScreen(
        afterSplash: _setMainAppTheme(),
      ),
    );
  }
}
