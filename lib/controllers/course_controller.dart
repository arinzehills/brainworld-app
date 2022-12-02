import 'package:get/get.dart';

class CourseController extends GetxController {
  var allPost = <CourseReaction>[].obs;
}

class CourseReaction {
  CourseReaction({
    this.postId,
    this.userId,
    this.subscribersId,
    this.comments,
    this.likes,
    this.subscribers,
  });

  String? userId;
  String? postId;
  String? subscribersId;
  List<dynamic>? likes = [];
  List<dynamic>? comments = [];
  List<dynamic>? subscribers = [];

  factory CourseReaction.fromJson(Map<String, dynamic> json) => CourseReaction(
        userId: json["user_id"],
        subscribersId: json["subscribers_id"],
        postId: json["_id"],
        subscribers: json["subscribers"],
        likes: json["likes"],
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "post_id": postId,
        "subscribers_id": subscribersId,
        "likes": likes,
        "comments": comments,
        "subscribers": subscribers,
      };
}
