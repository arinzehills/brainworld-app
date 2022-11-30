import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/components/utilities_widgets/radial-gradient.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/models/cart_model.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/pages/checkout/checkout.dart';
import 'package:brainworld/pages/upload/course/course_desc.dart';
import 'package:brainworld/pages/upload/course/model/course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

final iconsColor = const Color(0xffC9C4C4);
// final generalUrl = "http://10.0.2.2:3000";
// final generalUrl = "http://localhost:3000";
final generalUrl = "https://brainworld-api.cyclic.app";
final textGreyColor = const Color(0xff4B4949);
final transparentGrey = const Color(0xffC9C4C4);
// final welcomepageBlue= const Color(0xff0837ff);
// final welcomepageLightBlue= const Color(0xff00dcff);
final myhomepageBlue = const Color(0xff2255FF);
final myhomepageLightBlue = const Color(0xff1477FF);
final myhomepageOrange = const Color(0xffFF5800);
final myhomepageLightOrange = const Color(0xffFF1453);
final mysocialblueGradient = [
  Color.fromARGB(35, 34, 86, 255),
  Color.fromARGB(65, 20, 118, 255)
];
final myblueGradient = [myhomepageBlue, myhomepageLightBlue];
final myblueGradientTransparent = [
  myhomepageBlue.withOpacity(0.73),
  myhomepageLightBlue
];
final myOrangeGradient = [myhomepageOrange, myhomepageLightOrange];
final myOrangeGradientTransparent = [
  myhomepageOrange.withOpacity(0.59),
  myhomepageLightOrange.withOpacity(0.38)
];
var textFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: const Color(0xff626262)),
  filled: true,
  fillColor: const Color(0xfff7f7f7),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(10.0),
  ),
);
GradientText generalGText({text, double? fontSize}) {
  return GradientText(
    text,
    style: TextStyle(fontSize: fontSize ?? 35, fontWeight: FontWeight.bold),
    gradient: LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.bottomRight,
        colors: [
          myhomepageLightBlue,
          const Color(0xff0837ff),
        ]),
  );
}

Size size(context) => MediaQuery.of(context).size;
User user(context) => Provider.of<User>(context, listen: false);

//for loading pop up

Future loadingStatus(context, text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        height: 127,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/girlwithpc.png',
              height: 65,
              width: 90,
            ),
            CircularProgressIndicator(
              color: myhomepageBlue,
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              'adding post...',
              style: TextStyle(color: myhomepageBlue),
            ),
          ],
        )),
      ),
    ),
  );
}

//snackbar
snackBar(page, context, text) {
  MyNavigate.navigatejustpush(page, context);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: myhomepageBlue,
      content: Text(text ?? 'Logged In Successfully')));
}

void seeDetailsModalBottomSheet(
    {required context,
    int? courseIndex,
    PostsController? postsController,
    Socket? socket,
    required cartController}) {
  PostsModel course = postsController!.allPost[courseIndex!];
  CartModel cartModel = CartModel.fromJson(course.toJson());
  print(cartModel.user_id);
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(30).copyWith(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: GradientText('Options',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            gradient: LinearGradient(
                              colors: [myhomepageBlue, myhomepageLightBlue],
                            ))),
                    RadiantGradientMask(
                      child: IconButton(
                        icon: Icon(
                          IconlyBold.close_square,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      placeHolder: 'See details',
                      widthRatio: 0.39,
                      isGradientButton: true,
                      gradientColors: myOrangeGradientTransparent,
                      pressed: () {
                        Get.to(Obx(
                          () => CourseDescPage(
                            course: postsController.allPost[courseIndex],
                            socket: socket!,
                          ),
                        ));
                      },
                    ),
                    MyButton(
                      placeHolder: 'Add to cart',
                      widthRatio: 0.42,
                      isGradientButton: true,
                      gradientColors: myblueGradientTransparent,
                      pressed: () {
                        cartController.addCourse(cartModel);
                      },
                    ),
                  ],
                ),
              ]),
        );
      });
}

void showPurchaseBottomSheet(
    {context,
    int? courseIndex,
    required PostsController postsController,
    cartController}) {
  PostsModel course = postsController.allPost[courseIndex!];
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Text(
                      course.price == '0'
                          ? 'Add to your courses'
                          : 'You have to purchase',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      widthRatio: 0.6,
                      withBorder: true,
                      gradientColors: myOrangeGradientTransparent,
                      isGradientButton: true,
                      placeHolder: course.price == '0' ? 'Add' : 'Add to Cart',
                      pressed: () {
                        //  course.package =='free' ?
                        //  DataBaseService(uid: uid)
                        //  .addMyCourse(course)
                        //  : addToCart(course,cartController);
                      },
                    ),
                    // course.package == 'free'
                    //     ? SizedBox()
                    //     : MyButton(
                    //         placeHolder: 'Purchase',
                    //         pressed: () {
                    //           // MyNavigate.navigatejustpush(
                    //           //     Checkout(
                    //           //       totalAmount: course.price,
                    //           //       course: course,
                    //           //     ),
                    //           //     context);
                    //         },
                    //       ),
                  ],
                ),
              ),
            ]);
      });
}
