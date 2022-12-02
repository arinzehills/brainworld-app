import 'dart:async';
import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/models/user_model.dart';
import 'package:brainworld/pages/auth_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Image(
        image: AssetImage(
          'assets/images/brainworld-logo.png',
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer = Timer(const Duration(microseconds: 500), () {
      _completeSplash();
    });
  }

  _completeSplash() async {
    final _user = Provider.of<User?>(context);
    if (_user == null) {
      return const  Login();
    } else {
      return const BottomNavigation();
    }
  }
}
