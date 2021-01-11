import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:splashscreen/splashscreen.dart';

///Splash screen shown in app launch. It is meant to be simple and to give
///a little time until the app initializes.
class AppSplashScreen extends StatelessWidget {
  final Future<Widget> afterSplash;
  const AppSplashScreen({
    Key key,
    this.afterSplash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: afterSplash,
      title: const Text(
        "Lista de Tarefas",
        style: TextStyle(fontSize: 32),
      ),
      image: const Image(
        image: Svg("assets/images/check-list2.svg"),
      ),
      photoSize: 100,
    );
  }
}
