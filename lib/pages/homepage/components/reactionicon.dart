import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReactionIcon extends StatelessWidget {
  final String iconUrl;
  final double? iconHeight;
  final bool? withMarginLeft;
  final String? text;
  final VoidCallback onClick;

  const ReactionIcon({
    Key? key,
    required this.onClick,
    required this.iconUrl,
    this.text,
    this.withMarginLeft = false,
    this.iconHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: withMarginLeft! ? 10 : 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClick,
            child: SvgPicture.asset(iconUrl,
                height: iconHeight ?? 21,
                // fit: BoxFit.fill,
                color: BrainWorldColors.myhomepageBlue,
                semanticsLabel: 'A red up arrow'),
          ),
          Text(text ?? ''),
        ],
      ),
    );
  }
}
