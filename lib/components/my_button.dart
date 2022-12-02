import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
 final  String placeHolder;
  final double? widthRatio;
  final double? height;
   final bool isOval;
  final bool withBorder;
  final bool isGradientButton;
 final  bool loadingState;
 final  List<Color>? gradientColors;
  final VoidCallback pressed;
 final  Widget? child;

 final double? fontSize;

 const MyButton({Key? key, 
    required this.placeHolder,
    this.child,
    this.isOval = false,
    this.withBorder = false,
    this.height,
    this.fontSize,
    this.widthRatio,
    this.isGradientButton = false,
    this.loadingState = false,
    this.gradientColors,
    required this.pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: loadingState ? null : pressed,
      disabledColor: Colors.orange,
      disabledTextColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isOval ? 80.0 : 0.0)),
      padding: const EdgeInsets.all(0.0),
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
          borderRadius: BorderRadius.all(Radius.circular(isOval ? 30 : 8)),
        ),
        child: loadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Container(
                constraints: const BoxConstraints(
                    minWidth: 88.0,
                    minHeight: 36.0), // min sizes for Material buttons
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      placeHolder,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSize ?? 23),
                    ),
                    child ?? const SizedBox(),
                  ],
                ),
              ),
      ),
    );
  }
}
