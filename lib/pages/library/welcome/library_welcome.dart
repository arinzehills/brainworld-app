import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/nothing_yet_widget.dart';
import 'package:brainworld/constants/api_utils_constants.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/models/isnewuser_data_model.dart';
import 'package:brainworld/pages/library/welcome/select_library.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';

class LibraryWelcome extends StatefulWidget {
  const LibraryWelcome({Key? key}) : super(key: key);

  @override
  State<LibraryWelcome> createState() => _LibraryWelcomeState();
}

class _LibraryWelcomeState extends State<LibraryWelcome> {
  late IsNewUserModel userInfoData;
  bool showIntroPage = true; //i.e show d intro page
  @override
  void initState() {
    super.initState();
    _getUserRegInfo();
  }

  _getUserRegInfo() async {
    var userInfo = await getUserRegInfo();
    if (this.mounted) {
      setState(() {
        userInfoData = IsNewUserModel.fromJson(userInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context);

    return Scaffold(
      drawer: MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.091,
          ),
          Text(
            'Choose Library to Access',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          Image.asset(
            "assets/images/picture.png",
            height: 240,
          ),
          MyButton(
            placeHolder: 'Access',
            height: 55,
            isGradientButton: true,
            isOval: true,
            gradientColors: myOrangeGradientTransparent,
            widthRatio: 0.80,
            pressed: () async {
              // Get.to(StartNewClass());
              comingSoon(context);
            },
          ),
        ],
      ),
    );
  }
}

Future comingSoon(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: myhomepageBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        height: 357,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dullbaby.png',
              height: 250,
              width: 290,
            ),
            Text(
              'Coming Soon..',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 7,
            ),
            MyButton(
              placeHolder: 'View Demo',
              height: 55,
              isGradientButton: true,
              isOval: true,
              gradientColors: myOrangeGradientTransparent,
              widthRatio: 0.70,
              pressed: () async {
                // Get.to(StartNewClass());
                // comingSoon(context);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () async {
                          return true;
                          // return
                          // Navigator.of(context).pushAndRemoveUntil(
                          //   MaterialPageRoute(builder: (context) =>
                          //   Authenticated()),
                          //    (Route<dynamic> route) => false);
                        },
                        child: Center(
                            child: SelectLibrary(
                          title: "PLACE ORDER",
                        )),
                      );
                    });
              },
            ),
          ],
        )),
      ),
    ),
  );
}
