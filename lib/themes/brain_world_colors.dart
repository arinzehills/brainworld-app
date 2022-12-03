import 'package:flutter/material.dart';

class BrainWorldColors {
  static const iconsColors = Color(0xffC9C4C4);
  static const textGreyColor = Color(0xff4B4949);
  static const transparentGrey = Color(0xffC9C4C4);
  static const myhomepageBlue = Color(0xff2255FF);
  static const myhomepageLightBlue = Color(0xff1477FF);
  static const myhomepageOrange = Color(0xffFF5800);
  static const myhomepageLightOrange = Color(0xffFF1453);
  static const mysocialblueGradient = [
    Color.fromARGB(35, 34, 86, 255),
    Color.fromARGB(65, 20, 118, 255)
  ];
  static const welcomepageBlue = Color(0xff0837ff);
  static const welcomepageLightBlue = Color(0xff00dcff);
  static const myblueGradient = [
    BrainWorldColors.myhomepageBlue,
    BrainWorldColors.myhomepageLightBlue
  ];
  static final myblueGradientTransparent = [
    BrainWorldColors.myhomepageBlue.withOpacity(0.73),
    BrainWorldColors.myhomepageLightBlue
  ];
  static const myOrangeGradient = [
    BrainWorldColors.myhomepageOrange,
    BrainWorldColors.myhomepageLightOrange
  ];
  static final myOrangeGradientTransparent = [
    BrainWorldColors.myhomepageOrange.withOpacity(0.59),
    BrainWorldColors.myhomepageLightOrange.withOpacity(0.38)
  ];
  //TODO: ADD APP TEXT COLOR
}
