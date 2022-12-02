import 'package:brainworld/themes/themes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SpinKitThreeInOut(
          color: BrainWorldColors.myhomepageBlue,
          size: 50.0,
        ),
      ),
    );
  }
}
