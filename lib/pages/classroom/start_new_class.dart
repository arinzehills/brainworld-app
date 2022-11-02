import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/upload/add_to_local_library.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class StartNewClass extends StatefulWidget {
  const StartNewClass({
    Key? key,
  }) : super(key: key);

  @override
  State<StartNewClass> createState() => _StartNewClassState();
}

class _StartNewClassState extends State<StartNewClass> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool autovalidate = false;

    return Scaffold(
      drawer: MyDrawer(),
      body: Column(
        children: [
          NormalCurveContainer(
            size: size,
            height: size.height * 0.21,
            // showDrawer: true,
            container_radius: 90,
            // pagetitle: '2',
            widget: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Start new class',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Image.asset(
            "assets/images/picture.png",
            height: 240,
            width: 220,
          ),
          Padding(
            padding: EdgeInsets.all(14).copyWith(bottom: 1),
            child: MyTextField(
              hintText: 'Enter Meeting code',
              autovalidate: autovalidate,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (val) {
                if (mounted) {
                  setState(() => password = val);
                }
              },
              onTap: () {
                if (autovalidate == true) {
                  setState(() {
                    autovalidate = false;
                  });
                } else {
                  setState(() {
                    autovalidate = true;
                  });
                }
              },
              validator: MultiValidator([
                RequiredValidator(errorText: 'Required'),
                MinLengthValidator(6,
                    errorText: 'Password must be at least 6 character long'),
              ]),
              suffixIconButton: IconButton(
                icon: const Icon(Icons.copy),
                color: myhomepageBlue,
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MyButton(
            placeHolder: 'Start new class',
            height: 55,
            isGradientButton: true,
            isOval: true,
            gradientColors: myblueGradientTransparent,
            widthRatio: 0.80,
            pressed: () async {
              Get.to(AddToLocalLibray());
            },
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Share link',
              style: TextStyle(
                  color: myhomepageBlue.withOpacity(0.7),
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
