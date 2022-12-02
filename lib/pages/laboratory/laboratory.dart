import 'package:brainworld/components/nothing_yet_widget.dart';
import 'package:flutter/material.dart';

class Laboratory extends StatefulWidget {
  const Laboratory({Key? key}) : super(key: key);

  @override
  State<Laboratory> createState() => _LaboratoryState();
}

class _LaboratoryState extends State<Laboratory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NothingYetWidget(
        pageTitle: 'START LAB PRACTICE',
        pageHeader: "Lab Test Taken",
        pageContentText: 'This is a virtual lab built for you to practice and'
            ' implement your tests and class activity'
            'You have\n not started any laboratory test here it',
      ),
    );
  }
}
