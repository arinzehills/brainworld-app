import 'dart:math';

import 'package:brainworld/components/bottomnavcomponents/bottomnavcomponents.dart';
import 'package:brainworld/components/comment_fieldbox.dart';
import 'package:brainworld/components/my_cachednetwork_image.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/components/chat_icon_gradient.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/pages/homepage/components/reactionicon.dart';
import 'package:brainworld/pages/upload/course/model/course.dart';
import 'package:brainworld/pages/upload/post_detail.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CoursesTile extends StatefulWidget {
  PostsModel post;
  String? commenttoShow;
  Socket socket;
  PostsController? postsController;
  int? courseIndex;

  bool isCommentDetail;
  CoursesTile(
      {Key? key,
      required this.post,
      required this.socket,
      this.postsController,
      this.commenttoShow,
      this.courseIndex,
      this.isCommentDetail = false})
      : super(key: key);

  @override
  State<CoursesTile> createState() => _CoursesTileState();
}

class _CoursesTileState extends State<CoursesTile> {
  final _controller = TextEditingController();
  final cartController = Get.put(CartService());

  String comment = '';

  bool showCommentBox = false;
  @override
  Widget build(BuildContext context) {
    print(comment);
    final user = Provider.of<User>(context);
    int commentlength = widget.post.comments!.length;

    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfileUserWidget(
                    userId: widget.post.user_id!,
                    // comment: 'Brain World',
                    containerWidthRatio: 0.72,
                    imageUrl: widget.post.imageUrl,
                    imageHeight: 60,
                    imageWidth: 60,
                  ),
                ],
              ),
              Row(
                children: [
                  ReactionIcon(
                      onClick: () {},
                      iconUrl: widget.post.postType == 'course'
                          ? 'assets/svg/gragicon.svg'
                          : 'assets/svg/posticon.svg'),
                  IconButton(
                      onPressed: () {
                        print(widget.post.videoUrls);
                        widget.post.postType == 'course'
                            ? seeDetailsModalBottomSheet(
                                context: context,
                                socket: widget.socket,
                                postsController: widget.postsController!,
                                courseIndex: widget.courseIndex,
                                cartController: cartController)
                            : Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                msg: "Not a course",
                                backgroundColor: myhomepageBlue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                      },
                      icon: Icon(
                        Icons.more_vert_sharp,
                        size: 25,
                        color: Color.fromARGB(255, 45, 45, 45),
                      )),
                ],
              ),
            ],
          ),
          widget.post.imageUrl != null
              ? Center(
                  child: MyCachedNetworkImage(
                    imgUrl: widget.post.imageUrl!,
                    height: 130,
                    width: 120,
                  ),
                )
              : Image.asset(
                  'assets/images/womanwithlaptop.jpeg',
                  height: 120,
                  width: 600,
                ),
          Container(
            height: 20,
            child: Text(
              widget.post.title!.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 32,
            width: size(context).width * 0.96,
            child: Text(
              widget.post.caption ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textGreyColor, fontSize: 13),
            ),
          ),
          reactionRow(user, commentlength),
          widget.isCommentDetail
              ? (showCommentBox ? SizedBox() : SizedBox())
              : showCommentBox
                  ? commentBox(commentlength, user)
                  : SizedBox()
        ],
      ),
    );
  }

  commentBox(int commentlength, User user) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commentlength != 0
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 17),
                  ),
                  onPressed: null,
                  child: Text(
                    'View all ${commentlength} comments',
                    style: TextStyle(color: myhomepageBlue),
                  ),
                )
              : SizedBox(),
          commentlength == 0
              ? Center(
                  child: Text('No Comment for this post'),
                )
              : ProfileUserWidget(
                  userId: widget.post.comments!.last['user_id'],
                  isUtilityType: true,
                  subTitle: widget.post.comments!.last['comment'],
                  // comment: widget.post.comments!.last['comment'],
                ),
          // Text(commentlength != 0 ? widget.post.comments!.last['comment'] : ''),
          CommentFieldBox(post: widget.post, socket: widget.socket)
        ],
      ),
    );
  }

  Container reactionRow(User user, int commentlength) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          gradient: LinearGradient(colors: [
            Color.fromARGB(35, 34, 86, 255),
            Color.fromARGB(65, 20, 118, 255)
          ], begin: Alignment.topCenter)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ReactionIcon(
                iconUrl: 'assets/svg/loveicon.svg',
                onClick: () async {
                  likePost(widget.post.post_id, user.id);
                },
              ),
              Text(widget.post.likes!.length.toString()),
              SizedBox(
                width: 5,
              ),
              ReactionIcon(
                iconUrl: 'assets/svg/commenticon.svg',
                onClick: () {
                  setState(() {
                    showCommentBox = !showCommentBox;
                  });
                },
              ),
              Text(commentlength.toString()),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 5,
              ),
              ReactionIcon(iconUrl: 'assets/svg/sendicon.svg', onClick: () {}),
            ],
          ),
          ReactionIcon(
            iconUrl: 'assets/svg/saveposticon.svg',
            iconHeight: 26,
            onClick: () {},
          ),
        ],
      ),
    );
  }

  Future<void> likePost(postid, userid) async {
    // FocusScope.of(context).unfocus(); //this unfocusses the keybaord
    var postReaction = {
      "reactionType": 'like',
      "post_id": postid,
      "user_id": userid,
    };

    widget.socket.emit('postReaction', {
      "postReaction": postReaction,
    }); //sends data to back
  }

  void sendComment(postid, userid, comment) {
    var postReaction = {
      "reactionType": 'comment',
      "post_id": postid,
      "user_id": userid,
      "comment": comment,
    };

    widget.socket.emit('postReaction', {
      "postReaction": postReaction,
    });
    _controller.clear(); //clears the text in the text field
  }
}
