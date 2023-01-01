import 'package:flutter/material.dart';
import 'pages/splash_screen/splash_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
    // return const BottomNavigation();
  }
}
