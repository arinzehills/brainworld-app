import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ExpandableTextWidget extends StatefulWidget {
  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  bool flag = true;
  @override
  void initState() {
    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.text.length);
    print(flag);

    return Container(
      child: secondHalf.length == ''
          ? Text(widget.text)
          : Column(
              children: [
                Text(flag ? firstHalf : widget.text),
                GestureDetector(
                  onTap: (() => setState(() => {flag = !flag})),
                  child: Row(
                    children: [
                      Text(
                        flag ? 'Show more' : 'Show less',
                        style: const TextStyle(
                            color: BrainWorldColors.myhomepageBlue, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                          flag
                              ? IconlyLight.arrow_down_2
                              : IconlyLight.arrow_up_2,
                          size: 18,
                          color: BrainWorldColors.myhomepageBlue)
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
