import 'package:brainworld/constants/api_utils_constants.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/cart_model.dart';
import 'package:brainworld/pages/chats/models/order_info.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartService extends GetxController {
  final _cartItems = {}.obs;

  void addCourse(CartModel cartItem) {
    if (_cartItems.containsKey(cartItem)) {
      Get.snackbar('Item  already in cart',
          'You have added the ${cartItem.title} to the cart ',
          // "You have added a product with ${cartItem.courseType}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: myhomepageBlue.withOpacity(0.5),
          colorText: Colors.white,
          duration: const Duration(seconds: 1));
    } else {
      _cartItems[cartItem] = 1;

      Get.snackbar('Item added to cart',
          'You have added the ${cartItem.title} to the cart ',
          // "You have added a product with ${cartItem.courseType}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: myhomepageBlue.withOpacity(0.5),
          colorText: Colors.white,
          duration: const Duration(milliseconds: 800));
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
          duration: const Duration(milliseconds: 900));
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
          orderId: order_id,
          userId: cartItems[i].userId,
          currentUserId: user(context).id,
          postId: cartItems[i].postId!,
          orderType: cartItems[i].postType,
          currentUsserName: user(context).fullName,
          email: user(context).email,
          title: cartItems[i].title,
          price: cartItems[i].price);
      AuthService().postData(order.toJson(), 'payment/orderItem');
    }
  }
}
