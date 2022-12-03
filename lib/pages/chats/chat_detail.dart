import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/chat_controller.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/chats/components/build_message_list.dart';
import 'package:brainworld/pages/chats/components/chat_icon_gradient.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
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
  String groupChatId = '';
  final _controller = TextEditingController();
  ChatController chatController = ChatController();

  late Socket socket;
  @override
  void initState() {
    readLocal();
    socketServer();
    Future.delayed(const Duration(microseconds: 2));

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
            padding: const EdgeInsets.only(right: 3),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(105, 237, 235, 235)),
                    child: const Center(
                      child: Icon(
                        IconlyBold.arrow_left,
                        color: BrainWorldColors.iconsColors,
                      ),
                    ),
                  ),
                ),
                ProfileUserWidget(
                    userId: widget.clickeduserid,
                    subTitle: 'Online now',
                    subTitleColor: const Color(0xff18DE4E),
                    headerFontSize: 16,
                    withGapBwText: true,
                    containerWidthRatio: 0.69,
                    skeltonWidth: 50),
                const Icon(IconlyBold.call,
                    color: BrainWorldColors.iconsColors),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  IconlyBold.video,
                  color: BrainWorldColors.iconsColors,
                ),
                const SizedBox(
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
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 100,
            width: double.infinity,
            color: const Color.fromARGB(255, 224, 230, 250),
            child: Row(
              children: <Widget>[
                ChatIconGradient(
                  pressed: () {},
                  iconName: Icons.add,
                  bgColor: BrainWorldColors.myblueGradientTransparent,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    IconlyBold.voice,
                    color: BrainWorldColors.iconsColors,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.red,
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Color(0xffC9C4C4)),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
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
                  bgColor: BrainWorldColors.myOrangeGradientTransparent,
                ),
                const SizedBox(
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
    final _logger = Logger();

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
      socket.on('connect', (data) => _logger.d('Connected:' + socket.id!));
    } catch (e) {
      _logger.d(e.toString());
    }
  }

  setupSocketListener() {
    final _logger = Logger();

    socket.on('_getAllChats', (data) {
      var chats = data['chats'];
      for (var data in chats) {
        dynamic list = Provider.of<ChatController>(context, listen: false)
            .messages
            .where((chat) => chat.id == data['_id']);
        _logger.d(list.length);
        Future.delayed(const Duration(microseconds: 2));
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
