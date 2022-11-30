import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 0),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
      );
}
