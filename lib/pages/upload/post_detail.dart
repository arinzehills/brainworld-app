import 'package:brainworld/components/comment_fieldbox.dart';
import 'package:brainworld/components/course_tile.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user_model.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PostDetail extends StatefulWidget {
  final PostsModel post;
  final Socket socket;
  const PostDetail({Key? key, required this.post, required this.socket})
      : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            IconlyBold.arrow_left,
            color: BrainWorldColors.myhomepageLightBlue,
          ),
        ),
        elevation: 0,
        title: const Text(
          'Post',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CoursesTile(
                  post: widget.post,
                  socket: widget.socket,
                  isCommentDetail: true,
                ),
                SizedBox(
                  height: size(context).height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: ListView.builder(
                        itemCount: widget.post.comments!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          bool isUser = widget.post.comments![index]
                                  ['user_id'] ==
                              user.id;
                          return Align(
                              alignment: isUser
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: commentBox(index, isUser));
                        }),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CommentFieldBox(
                isCommentDetail: true,
                post: widget.post,
                socket: widget.socket,
              ),
            )
          ],
        ),
      ),
    );
  }

  commentBox(index, isUser) {
    return Container(
        // height: 70,
        constraints: BoxConstraints(
          minHeight: isUser ? 70 : 0,
        ),
        width: isUser ? null : size(context).width * 0.6,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: !isUser ? Colors.grey.shade200 : null,
          gradient: !isUser
              ? null
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      const Color(0xff2255FF),
                      const Color(0xff1477FF).withOpacity(0.9),
                    ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isUser
                ? const SizedBox()
                : ProfileUserWidget(
                    userId: widget.post.comments![index]['user_id'],
                    isUtilityType: true,
                  ),
            Text(
              widget.post.comments![index]['comment'],
              style: TextStyle(
                  fontSize: 18, color: !isUser ? Colors.black : Colors.white),
            ),
          ],
        ));
  }
}
