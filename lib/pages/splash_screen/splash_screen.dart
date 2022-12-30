import 'dart:async';
import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/auth_screens/login.dart';
import 'package:brainworld/pages/getstarted_page.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
        height: 180,
        width: 180,
        image: AssetImage(
          'assets/images/brainworld-logo.png',
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer = Timer(const Duration(milliseconds: 500), () {
      _completeSplash();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  _completeSplash() async {
    final user = Provider.of<User?>(context, listen: false);

    String? hasAccessToken = (user?.token);
    final logger = Logger();

    logger.d("this toke: $hasAccessToken");
    if (hasAccessToken != null) {
      return const BottomNavigation();
    } else {
      const Login();
    }
  }
}
