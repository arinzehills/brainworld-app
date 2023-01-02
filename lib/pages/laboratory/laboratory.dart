import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/nothing_yet_widget.dart';
import 'package:brainworld/pages/upload/add_to_local_library.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Laboratory extends StatefulWidget {
  const Laboratory({Key? key}) : super(key: key);

  @override
  State<Laboratory> createState() => _LaboratoryState();
}

class _LaboratoryState extends State<Laboratory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NothingYetWidget(
        pageTitle: 'START LAB PRACTICE',
        pageHeader: "Lab Test Taken",
        pageContentText: 'This is a virtual lab built for you to practice and'
            ' implement your tests and class activity'
            'You have\n not started any laboratory test here it',
        widget: MyButton(
          placeHolder: 'Start',
          height: 55,
          isGradientButton: true,
          isOval: true,
          gradientColors: BrainWorldColors.myblueGradientTransparent,
          widthRatio: 0.80,
          pressed: () async {
            Get.to(const AddToLocalLibray());
          },
        ),
      ),
    );
  }
}
