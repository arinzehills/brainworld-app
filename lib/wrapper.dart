// import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'components/bottomnavigation.dart';
// import 'pages/auth_screens/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
    // final user = Provider.of<User?>(context);

    // if (user == null) {
    //   return const Login();
    // } else {
    //   return const BottomNavigation();
    // }
  }
}
