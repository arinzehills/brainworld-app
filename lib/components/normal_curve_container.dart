import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NormalCurveContainer extends StatelessWidget {
  final String? pagetitle;
  final Widget? widget;
  final String? imageUrl;
  final String? searchHint;
  final double? containerRadius;
  final bool showDrawer;
  final double height;
  const NormalCurveContainer({
    Key? key,
    required this.size,
    this.pagetitle,
    this.widget,
    this.showDrawer = false,
    this.searchHint,
    this.containerRadius,
    required this.height,
    this.imageUrl,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(containerRadius ?? 110)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: myblueGradient)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showDrawer)
                    IconButton(
                      onPressed: () => {
                        if (imageUrl == null)
                          {Scaffold.of(context).openDrawer()}
                        else
                          {Navigator.pop(context)}
                      },
                      icon: SvgPicture.asset(
                          imageUrl == null
                              ? 'assets/svg/menuicon.svg'
                              : imageUrl!,
                          // height: 10,
                          // fit: BoxFit.fill,
                          color: Colors.white,
                          semanticsLabel: 'A red up arrow'),
                    ),
                  Text(
                    pagetitle ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            widget ?? const SizedBox(),
          ]),
    );
  }
}
