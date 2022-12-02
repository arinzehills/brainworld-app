import 'package:brainworld/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
   final String hintText;
   final String? initiaiValue;
   final String? value;
   final bool? obscureText;
   final bool? autovalidate;
   final TextInputType? keyboardType;
  final  Function()? onTap;
  final Function(String)? onChanged;
  // final VoidCallback pressed;
  final IconButton? suffixIconButton;
 final  Icon? prefixIcon;
 final  String? Function(String?)? validator;
  final bool isNumberOnly;

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

  const MyTextField({Key? key, 
    required this.hintText,
    this.initiaiValue,
    // required this.pressed,
    this.suffixIconButton,
    this.value,
    this.obscureText,
    this.validator,
    this.autovalidate,
    this.isNumberOnly = false,
    this.onTap,
    this.onChanged,
    this.keyboardType, this.prefixIcon,
  }) : super(key: key);

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
      inputFormatters: widget.isNumberOnly
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
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
