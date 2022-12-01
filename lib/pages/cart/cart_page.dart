import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/components/utilities_widgets/radial_gradient.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/checkout/checkout.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

void showCartBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return MyCartWidget();
      });
}

class MyCartWidget extends StatefulWidget {
  const MyCartWidget({
    Key? key,
    // required this.imgUrl,
  }) : super(key: key);

  // final List<String> imgUrl;

  @override
  State<MyCartWidget> createState() => _MyCartWidgetState();
}

class _MyCartWidgetState extends State<MyCartWidget> {
  @override
  Widget build(BuildContext context) {
    final CartService cartController = Get.find();

    // print(cartItems.price);
    return Obx(
      () => Stack(
        children: [
          cartController.cartItems.length != 0 //if cart is not empty
              ? Padding(
                  padding: const EdgeInsets.only(top: 35.0, bottom: 80),
                  child: ListView.builder(
                      itemCount: cartController.cartItems.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      //  padding: EdgeInsets.only(top: 10,bottom: 10),
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final cartItems =
                            cartController.cartItems.keys.toList();
                        return cartListWidget(cartItems, index, cartController);
                      }),
                )
              : Padding(
                  //no items
                  padding: const EdgeInsets.only(top: 88.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Items in cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/images/dullbaby.png',
                            height: 250,
                            width: 290,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          //the header of the cart
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: GradientText(
                          'Your cart(${cartController.cartItems.length})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          gradient: LinearGradient(
                            colors: [myhomepageBlue, myhomepageLightBlue],
                          ))),
                  SizedBox(
                    width: 60,
                  ),
                  OutlineButton(
                    color: myhomepageBlue,
                    disabledBorderColor: myhomepageLightOrange,
                    borderSide: BorderSide(color: myhomepageBlue),
                    onPressed: () {
                      cartController.removeAllCourses();
                    },
                    child: Text(
                      'Empty cart',
                      style: TextStyle(color: myhomepageBlue),
                    ),
                  ),
                  RadiantGradientMask(
                    child: IconButton(
                      icon: Icon(
                        //  Icons.cabin,
                        IconlyBold.close_square,
                        color: myhomepageBlue,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //checkout widget
          if (cartController.cartItems.length != 0)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  height: 85,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 0,
                            offset: Offset(5, 20)),
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [myhomepageLightBlue, myhomepageBlue])),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'NGN ${cartController.total}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 6, right: 10),
                        child: MyButton(
                          placeHolder: 'Checkout',
                          widthRatio: 0.4,
                          isOval: true,
                          pressed: () {
                            MyNavigate.navigatejustpush(Checkout(), context);
                          },
                          isGradientButton: true,
                          gradientColors: myOrangeGradientTransparent,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Padding cartListWidget(cartItems, int index, CartService cartController) {
    print('cartItems[index].imageUrl');
    print(cartItems[index].imageUrl);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 92,
        padding: EdgeInsets.only(left: 4, right: 16, top: 3, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 50.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ProfileUserWidget(
              userId: cartItems[index].userId,
              // isUtilityType: true,
              isCircular: false,
              imageUrl: cartItems[index].imageUrl,
              isUserSubtitle: true,
              comment: cartItems[index].title,
              containerWidthRatio: 0.73,
              withGapBwText: true,
              imageHeight: 60,
              showbgColor: false,
              imageWidth: 60,
              // comment: widget.post.comments!.last['comment'],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "NGN" + cartItems[index].price,
                  style: TextStyle(
                    fontSize: 13, color: myhomepageBlue,
                    // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                  ),
                ),
                GestureDetector(
                  onTap: () => cartController.removeCourse(cartItems[index]),
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            colors: myOrangeGradientTransparent)),
                    child: Center(
                        child: Icon(
                      IconlyBold.delete,
                      color: Colors.white,
                      size: 13,
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
