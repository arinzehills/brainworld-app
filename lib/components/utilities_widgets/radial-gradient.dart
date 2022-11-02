import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child, this.isGrey});
  final Widget child;
  final bool? isGrey;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          // center: Alignment.centerRight,
          // radius: 1,
          colors: isGrey == true
              ? [iconsColor, iconsColor]
              :
              // myblueGradientTransparent,
              <Color>[
                  Color(0xff2255FF).withOpacity(0.73),
                  const Color(0xff1477FF),
                ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
