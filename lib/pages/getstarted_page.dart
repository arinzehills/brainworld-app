import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/auth_screens/register.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({
    Key? key,
  }) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          //    Positioned(
          //   top: -321,
          //   right: -139,
          //   child: Image.asset(
          //     'assets/mycurve.png',
          //     width:size.height * 0.805,
          //     height:1000,
          //     ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 139.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 100,
                        child: Image.asset('assets/images/picture.png')),
                    generalGText(text: 'GET STARTED'),
                    GradientText(
                      '...a perfect  place to learn',
                      gradient: LinearGradient(
                          colors: BrainWorldColors.myOrangeGradientTransparent),
                      style: const TextStyle(
                          color: Color(0xffffb00b), fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          BrainWorldColors.myhomepageBlue,
                          BrainWorldColors.myhomepageLightBlue
                        ])),
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: Column(
                    children: [
                      MyButton(
                        placeHolder: 'Continue',
                        pressed: () async {
                          MyNavigate.navigatejustpush(
                              const Register(), context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      )),
    );
  }
}
