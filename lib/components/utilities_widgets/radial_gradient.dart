import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({Key? key, required this.child, this.isGrey})
      : super(key: key);
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
              ? [BrainWorldColors.iconsColors, BrainWorldColors.iconsColors]
              :
              // myblueGradientTransparent,
              <Color>[
                  const Color(0xff2255FF).withOpacity(0.73),
                  const Color(0xff1477FF),
                ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
