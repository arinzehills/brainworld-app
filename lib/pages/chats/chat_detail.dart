import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/chat_controller.dart';
import 'package:brainworld/pages/chats/components/build_message_list.dart';
import 'package:brainworld/pages/chats/components/chat_icon_gradient.dart';
import 'package:brainworld/pages/chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatDetail extends StatefulWidget {
  final String sendersid;
  final String clickeduserid;
  final String? senderEmail;
  final String? clickedEmail;
  //this is  identifies the user that u click to view his chat
  final String? name;
  const ChatDetail(
      {Key? key,
      required this.clickeduserid,
      required this.sendersid,
      this.clickedEmail,
      this.senderEmail,
      this.name})
      : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  bool showimg = false;
  String groupChatId = '';
  final _controller = TextEditingController();
  ChatController chatController = ChatController();

  late Socket socket;
  @override
  void initState() {
    readLocal();
    socketServer();
    Future.delayed(Duration(microseconds: 2));

    socket.emit('sendMessage', {
      {'chatID': groupChatId, "data": null}
    });
    setupSocketListener();
    super.initState();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(105, 237, 235, 235)),
                    child: Center(
                      child: Icon(
                        IconlyBold.arrow_left,
                        color: iconsColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                showimg
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.network(
                          'widget.imgUrl!',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, stackTrace) {
                            return ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                child: Image.asset(
                                  "assets/images/green native.png",
                                  height: 50,
                                ));
                          },
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.asset(
                          "assets/images/green native.png",
                          height: 50,
                        )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online now",
                        style:
                            TextStyle(color: Color(0xff18DE4E), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(IconlyBold.call, color: iconsColor),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  IconlyBold.video,
                  color: iconsColor,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Consumer<ChatController>(builder: (_, provider, __) {
          return BuildMessageList(
            itemCount: provider.messages.length,
            messages: provider.messages.reversed.toList(),
            sendersid: widget.sendersid,
          );
        }),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 100,
            width: double.infinity,
            color: Color.fromARGB(255, 224, 230, 250),
            child: Row(
              children: <Widget>[
                ChatIconGradient(
                  pressed: () {},
                  iconName: Icons.add,
                  bgColor: myblueGradientTransparent,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    IconlyBold.voice,
                    color: iconsColor,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        fillColor: Colors.red,
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Color(0xffC9C4C4)),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ChatIconGradient(
                    pressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        sendMessage();
                      }
                    },
                    iconName: IconlyBold.send,
                    iconSize: 30,
                    bgHeight: 60,
                    bgColor: myOrangeGradientTransparent),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void socketServer() {
    try {
      // socket = io(
      //     generalUrl,
      //     OptionBuilder()
      //         .setTransports(['websockets'])
      //         .enableForceNew()
      //         .disableAutoConnect()
      //         .build());

      //   //Configure socket Transport
      socket = io(generalUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'forceNew': true
      });
      socket.connect();
      socket.on('connect', (data) => print('Connected:' + socket.id!));
    } catch (e) {
      print(e.toString());
    }
  }

  setupSocketListener() {
    socket.on('_getAllChats', (data) {
      var chats = data['chats'];
      for (var data in chats) {
        dynamic list = Provider.of<ChatController>(context, listen: false)
            .messages
            .where((chat) => chat.id == data['_id']);
        print(list.length);
        Future.delayed(Duration(microseconds: 2));
        if (list.length == 0) {
          Provider.of<ChatController>(context, listen: false)
              .addNewMessage(UsersMessage.fromJson(data));
          //   });
        }
      }
    });
  }

  void readLocal() {
    String currentUserId = widget.sendersid;
    String peerId = widget.clickeduserid;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  Future<void> sendMessage() async {
    // FocusScope.of(context).unfocus(); //this unfocusses the keybaord
    Map<String, dynamic>? messageJson = {
      "sendersid": widget.sendersid,
      "senderEmail": widget.senderEmail,
      "receiverEmail": widget.senderEmail,
      "messageText": _controller.text,
      "sentAt": DateTime.now().toString(),
    };
    socket.emit('sendMessage',
        {"data": messageJson, "chatID": groupChatId}); //sends data to back
    _controller.clear(); //clears the text in the text field
  }
}
