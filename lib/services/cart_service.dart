import 'dart:convert';

import 'package:brainworld/constants/api_utils_constants.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/cart_model.dart';
import 'package:brainworld/pages/chats/models/order_info.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartService extends GetxController {
  var _cartItems = {}.obs;

  void addCourse(CartModel cartItem) {
    if (_cartItems.containsKey(cartItem)) {
      Get.snackbar('Item  already in cart',
          'You have added the ${cartItem.title} to the cart ',
          // "You have added a product with ${cartItem.courseType}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: myhomepageBlue.withOpacity(0.5),
          colorText: Colors.white,
          duration: Duration(seconds: 1));
    } else {
      _cartItems[cartItem] = 1;

      Get.snackbar('Item added to cart',
          'You have added the ${cartItem.title} to the cart ',
          // "You have added a product with ${cartItem.courseType}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: myhomepageBlue.withOpacity(0.5),
          colorText: Colors.white,
          duration: Duration(milliseconds: 800));
    }
  }

  void removeCourse(CartModel cartItem) {
    if (_cartItems.containsKey(cartItem)) {
      _cartItems.removeWhere((key, value) => key == cartItem);
      Get.snackbar(
          'Item removed', 'You have remove the ${cartItem.title} from cart ',
          // "You have added a product with ${cartItem.courseType}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: myhomepageBlue.withOpacity(0.5),
          colorText: Colors.white,
          duration: Duration(milliseconds: 900));
    }
  }

  void removeAllCourses() {
    _cartItems.clear();
  }

  get cartItems => _cartItems;

  get total => _cartItems.entries
      .map((cartItem) => int.parse(cartItem.key.price))
      .toList()
      .reduce(
        (value, element) => value + element,
      )
      .toString();

  static void purchaseCourse(cartItems, context) {
    for (var i = 0; i < cartItems.length; i++) {
      var order_id = generateRandomString(3) + DateTime.now().toIso8601String();
      OrderInfo order = OrderInfo(
          order_id: order_id,
          user_id: cartItems[i].user_id,
          current_user_id: user(context).id,
          post_id: cartItems[i].post_id!,
          orderType: cartItems[i].postType,
          current_user_name: user(context).full_name,
          email: user(context).email,
          title: cartItems[i].title,
          price: cartItems[i].price);
      AuthService().postData(order.toJson(), 'payment/orderItem');
    }
  }
}
