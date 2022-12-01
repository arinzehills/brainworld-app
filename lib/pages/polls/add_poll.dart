import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';

class AddPoll extends StatefulWidget {
  const AddPoll({Key? key}) : super(key: key);

  @override
  State<AddPoll> createState() => _AddPollState();
}

class _AddPollState extends State<AddPoll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NormalCurveContainer(
              widget: const Padding(
                padding:   EdgeInsets.all(48.0),
                child:  Center(
                    child:  Text(
                  'Add a poll ',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              size: size(context),
              height: size(context).height * 0.21),
        ],
      ),
    );
  }
}
