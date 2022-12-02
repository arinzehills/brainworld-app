import 'dart:convert';

import 'package:brainworld/components/utilities_widgets/mydate_formatter.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.userId, //id of the person who made the post or has the book
    this.currentUserId,
    required this.postId,
    required this.title,
    required this.price,
    required this.postType,
    this.imageUrl,
    this.orderedOn,
  });

  String userId; //this is the user that made the post
  String? currentUserId; //this is the user placing order
  String? postId;
  String title;
  String price;
  String postType; //either course or book
  String? imageUrl;
  String? orderedOn;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        userId: json["user_id"],
        currentUserId: json["current_user_id"],
        postId: json["post_id"],
        title: json["title"],
        price: json["price"],
        imageUrl: json["imageUrl"],
        postType: json["postType"],
        orderedOn: MyDateFormatter.dateFormatter(
          datetime:
              DateTime.parse(json['orderedOn'] ?? '2022-11-02 19:10:31.998691'),
        ),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "current_user_id": currentUserId,
        "post_id": postId,
        "title": title,
        "price": price,
        "imageUrl": imageUrl,
        "orderedOn": DateTime.now().toString(),
        "postType": postType,
      };
}
