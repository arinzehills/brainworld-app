import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class MyTextFieldDecoration {
  const MyTextFieldDecoration({Key? key});

  static InputDecoration textFieldDecoration(
      {VoidCallback? clickIcon, icon, hintText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: Colors.white,
      suffixIcon: clickIcon != null
          ? IconButton(
              icon: Icon(icon ?? IconlyBold.paper_upload),
              color: BrainWorldColors.myhomepageBlue,
              onPressed: clickIcon)
          : const SizedBox(),
      hintText: hintText ?? 'hintTExt',
      hintStyle: const TextStyle(
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: BrainWorldColors.myhomepageLightBlue, width: 0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
