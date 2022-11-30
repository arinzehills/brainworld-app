import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';

class NoAccount extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? pressed;
  const NoAccount({Key? key, required this.title, this.pressed, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title,
              style: TextStyle(
                  color: myhomepageBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
         const SizedBox(
            width: 10,
          ),
          GradientText(subtitle ?? '',
              style: const TextStyle(fontSize: 18),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomRight,
                colors: myOrangeGradient,
              ))
        ],
      ),
    );
  }
}
