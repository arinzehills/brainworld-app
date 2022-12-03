import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/chats/components/chat_icon_gradient.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CommentFieldBox extends StatefulWidget {
  final PostsModel post;
  final Socket socket;

  final bool isCommentDetail;
  const CommentFieldBox(
      {Key? key,
      required this.post,
      required this.socket,
      this.isCommentDetail = false})
      : super(key: key);

  @override
  State<CommentFieldBox> createState() => _CommentFieldBoxState();
}

class _CommentFieldBoxState extends State<CommentFieldBox> {
  final _controller = TextEditingController();

  String comment = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      color:
          widget.isCommentDetail ? BrainWorldColors.commentDetailColor : null,
      child: Row(
        children: [
          ChatIconGradient(
            pressed: null,
            bgHeight: 20,
            iconSize: 15,
            iconName: Icons.add,
            bgColor: BrainWorldColors.myblueGradientTransparent,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                  fillColor: Colors.red,
                  hintText: "Add a comment...",
                  hintStyle: TextStyle(color: BrainWorldColors.addCommentColor),
                  border: InputBorder.none),
              onTap: () {},
              onChanged: (value) => setState(() {
                comment = value;
              }),
            ),
          ),
          ChatIconGradient(
              pressed: _controller.text == ''
                  ? null
                  : () => sendComment(
                        widget.post.postId,
                        user.id,
                        comment,
                      ),
              iconName: IconlyBold.send,
              iconSize: 20,
              bgHeight: 35,
              bgColor: BrainWorldColors.myOrangeGradientTransparent),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
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
