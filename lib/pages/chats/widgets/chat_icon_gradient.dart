import 'package:flutter/material.dart';

class ChatIconGradient extends StatelessWidget {
  final IconData iconName;
  final List<Color> bgColor;
  final double? bgHeight;
  final double? iconSize;
  final VoidCallback? pressed;

  const ChatIconGradient(
      {Key? key,
      required this.iconName,
      required this.bgColor,
      this.bgHeight,
      required this.pressed,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        height: bgHeight ?? 30,
        width: bgHeight ?? 30,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: bgColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          iconName,
          color: Colors.white,
          size: iconSize ?? 20,
        ),
      ),
    );
  }
}
