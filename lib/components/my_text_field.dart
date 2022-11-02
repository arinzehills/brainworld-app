import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  String hintText;
  String? initiaiValue;
  String? value;
  bool? obscureText;
  bool? autovalidate;
  TextInputType? keyboardType;
  Function()? onTap;
  Function(String)? onChanged;
  // final VoidCallback pressed;
  IconButton? suffixIconButton;
  Icon? prefixIcon;
  String? Function(String?)? validator;

  // IconButton(
  //                                             icon: const Icon(Icons.visibility),
  //                                             color:iconsColor,
  //                                             onPressed: () {
  //                                              if(obscureText==true){
  //                                                 setState(() {
  //                                                   obscureText=false;
  //                                                 });
  //                                               }
  //                                               else{
  //                                                 setState(() {
  //                                             obscureText=true;
  //                                               });
  //                                               }
  //                                             },
  //                                         ),

  MyTextField({
    required this.hintText,
    this.initiaiValue,
    // required this.pressed,
    this.suffixIconButton,
    this.value,
    this.obscureText,
    this.validator,
    this.autovalidate,
    this.onTap,
    this.onChanged,
    this.keyboardType,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      // autovalidate: widget.autovalidate!,
      initialValue: widget.initiaiValue,
      keyboardType: widget.keyboardType,
      cursorHeight: 23,
      onTap: widget.onTap,
      obscureText: widget.obscureText ?? false,
      decoration: textFieldDecoration.copyWith(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIconButton,

        // suffixIcon: ,
        hintText: widget.hintText,
      ),
      onChanged: widget.onChanged,
    );
  }
}
