import 'package:brainworld/pages/auth_screens/login.dart';
// import 'package:brainworld/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return  Login();
  }
}
