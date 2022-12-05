import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.placeHolder,
      this.widthRatio,
      this.height,
      this.isOval = false,
      this.withBorder = false,
      this.isGradientButton = false,
      this.loadingState = false,
      this.gradientColors,
      required this.pressed,
      this.child,
      this.fontSize})
      : super(key: key);
  final String placeHolder;
  final double? widthRatio;
  final double? height;
  final bool isOval;
  final bool withBorder;
  final bool isGradientButton;
  final bool loadingState;
  final List<Color>? gradientColors;
  final VoidCallback pressed;
  final Widget? child;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loadingState ? null : pressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)? ,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isOval ? 80 : 0.0),
          ),
        ),
      ),
      child: Ink(
        width: MediaQuery.of(context).size.width * (widthRatio ?? 0.9),
        height: height ?? 62,
        decoration: BoxDecoration(
          border: withBorder ? Border.all(color: Colors.white) : null,
          gradient: isGradientButton
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(isOval ? 30 : 8),
          ),
        ),
        child: loadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  minHeight: 36.0,
                  minWidth: 88.0,
                ),
                child: Row(
                  children: [
                    Text(
                      placeHolder,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize ?? 23,
                      ),
                    ),
                    child ?? const SizedBox(),
                  ],
                ),
              ),
      ),
    );
  }
}
