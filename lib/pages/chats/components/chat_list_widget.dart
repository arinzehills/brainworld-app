// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/chat_controller.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../chat_detail.dart';

class ChatListWidget extends StatefulWidget {
  final String userid;
  final String clickedEmail;
  final Socket socket;
  final String name;
  final String? messageText;
  final String? imageUrl;
  final String? time;
  final bool? isMessageRead;
 const ChatListWidget(Key? key,
      {required this.userid,
      required this.name,
      required this.clickedEmail,
      required this.socket,
      @required this.messageText,
      @required this.imageUrl,
      @required this.time,
      @required this.isMessageRead})
      : super(key: key);
  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  var userData;
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    // print(userJson);
    var user = json.decode(userJson!);
    print(user['_id']);
    // User user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  @override
  void initState() {
    _getUserInfo();
  }

  List<String> imgUrl = [
    "assets/images/glory.png",
    "assets/images/GUC.jpeg",
    "assets/images/glory.png",
    // "assets/images/green native.png",
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.socket.close();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (context) => ChatController(),
                child: ChatDetail(
                    sendersid: userData['_id'],
                    clickeduserid: widget.userid,
                    senderEmail: userData['email'],
                    clickedEmail: widget.clickedEmail,
                    name: widget.name),
              ),
              //   {
              //   return ChatDetail(
              //     sendersid: userData['_id'],
              //     clickeduserid: widget.userid,
              //     senderEmail: userData['email'],
              //     clickedEmail: widget.clickedEmail,
              //     name: widget.name,
              //     // imgUrl: widget.imageUrl,
              //   );
              // }
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: 92,
          padding: EdgeInsets.only(left: 4, right: 16, top: 3, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 50.0,
                  spreadRadius: 2.0,
                ),
              ]),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ProfileUserWidget(
                userId: widget.userid,
                // isUtilityType: true,
                containerWidthRatio: 0.73,
                withGapBwText: true,
                imageHeight: 60,
                showbgColor: false,
                imageWidth: 60,
                // comment: widget.post.comments!.last['comment'],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.messageText!,
                    style: TextStyle(
                      fontSize: 13, color: BrainWorldColors.myhomepageBlue,
                      // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                    ),
                  ),
                  Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient:
                            LinearGradient(colors: myblueGradientTransparent)),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                            // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                            ),
                      ),
                    ),
                  )
                ],
              )
              // Text(
              // ),
              //   widget.time!,
              //   style: TextStyle(
              //     fontSize: 12,
              //     // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
