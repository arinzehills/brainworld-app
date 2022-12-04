import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

void showPurchaseBottomSheet(
    {context,
    int? courseIndex,
    required PostsController postsController,
    cartController}) {
  PostsModel course = postsController.allPost[courseIndex!];
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
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
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              IconButton(
                icon: const Icon(
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
                  gradientColors: BrainWorldColors.myOrangeGradientTransparent,
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
        ],
      );
    },
  );
}
