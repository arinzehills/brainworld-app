import 'dart:convert';

import 'package:brainworld/pages/chats/models/books_model.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/services/auth_service.dart';

class OrderService {
  //get all purchased orders
  static Future getUserOrders() async {
    var user = await AuthService().getuserFromStorage();

    var response = await AuthService()
        .postData({"token": user.token}, 'payment/getUserOrders');
    var responseData = json.decode(response.body);
    var postMap = responseData['books'];
    // print('responseData');
    return responseData;
  }

  static Future<List<PostsModel>> getUserPurchasedCourses() async {
    var ordersRequest = await OrderService.getUserOrders();

    var orderedCourses = ordersRequest['onCourses'];
    List<PostsModel> postsModel = [];
    for (var course in orderedCourses) {
      postsModel.add(PostsModel.fromJson(course));
    }
    return postsModel;
  }

  static Future<List<BookModel>> getUserPurchasedBooks() async {
    var ordersRequest = await OrderService.getUserOrders();

    var orderedBooks = ordersRequest['onBooks'];
    List<BookModel> booksModel = [];
    for (var book in orderedBooks) {
      booksModel.add(BookModel.fromJson(book));
    }
    return booksModel;
  }
}
