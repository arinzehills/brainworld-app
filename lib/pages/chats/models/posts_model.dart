import 'dart:convert';

import 'dart:io';

import 'package:brainworld/components/utilities_widgets/mydate_formatter.dart';

PostsModel chatModelFromJson(String str) =>
    PostsModel.fromJson(json.decode(str));

String chatModelToJson(PostsModel data) => json.encode(data.toJson());

class PostsModel {
  PostsModel({
    this.postId,
    this.userId,
    this.price,
    this.image,
    this.imageUrl,
    this.videoURL,
    this.title,
    this.postType,
    this.caption,
    this.requirements,
    this.category,
    this.postedOn,
    this.likes,
    this.comments,
    this.subTitles = const [],
    this.fileUrls,
    this.videoUrls,
  });

  String? userId;
  String? postId;
  String? title;
  String? price;
  String? caption;
  final String? requirements;
  final String? videoURL; //description video url

  String? postType;
  String? category;
  File? image;
  String? imageUrl;
  String? postedOn;
  final List<dynamic> subTitles; //they are 14
  List<dynamic>? likes = [];
  List<dynamic>? comments = [];
  final List? fileUrls;
  final List? videoUrls;

  factory PostsModel.fromJson(Map<String, dynamic> json) => PostsModel(
        userId: json["user_id"],
        postId: json["_id"],
        price: json["price"],
        // image: json["image"],
        imageUrl: json["image"],
        videoURL: json['video'],
        caption: json["caption"],
        requirements: json["requirements"],
        postType: json["postType"],
        category: json["caption"],
        title: json["title"],
        postedOn: MyDateFormatter.dateFormatter(
          datetime:
              DateTime.parse(json['postedOn'] ?? '2022-11-02 19:10:31.998691'),
        ),
        likes: json["likes"],
        comments: json["comments"],
        fileUrls: json["fileUrls"],
        videoUrls: json["videoUrls"],
        subTitles: json["subTitles"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "user_id": userId,
        "post_id": postId,
        "images": image,
        "imageUrl": imageUrl,
        "price": price,
        "postedOn": postedOn,
        "caption": caption,
        "postType": postType,
        "category": category,
        "likes": likes,
        "comments": comments,
      };
}
