import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  const NoItemsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      // color: Colors.red,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
              colors: BrainWorldColors.mysocialblueGradient,
              begin: Alignment.topCenter)),
      child: Column(
        children: [
          Image.asset('assets/images/dullbaby.png'),
          const Text('No Courses Purchased'),
          const SizedBox(
            height: 10,
          ),
          MyButton(
              placeHolder: "Start",
              pressed: () {},
              isOval: true,
              widthRatio: 0.5,
              isGradientButton: true,
              gradientColors: BrainWorldColors.myOrangeGradientTransparent)
        ],
      ),
    );
  }
}
