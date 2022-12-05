import 'package:brainworld/components/custom_sliver_delegate.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/chat_users_controller.dart';
import 'package:brainworld/models/user_model.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'widgets/chat_list_widget.dart';

class Chat extends StatefulWidget {
  // Socket chatSocket;
  const Chat({
    Key? key,
    // required this.chatSocket
  }) : super(key: key);

  Text buildText({title}) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    );
  }

  Widget buildNoChats(String text, Size size) => Center(
        child: Container(
            height: size.height * 0.31,
            width: size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: BrainWorldColors.myhomepageBlue.withOpacity(0.24),
                    // spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.white])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Image.asset(
                      "assets/images/dullbaby.png",
                      height: 110,
                    )),
                const Text(
                  ' no chats yet',
                )
              ],
            )),
      );

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Socket socket;
  ChatUsersController chatUsersListController = ChatUsersController();

  // List<User> users = [];
  @override
  void initState() {
    super.initState();
    socketServer();
    socket.emit('_getUsers', {'senderEmail': 'arinzehill@gmail.com'});
    socket.on('_allUsers', (allUsers) {
      // print(allUsers);

      for (var user in allUsers) {
        // users.add(_users);
        if (this.mounted) {
          if (user['email'] !=
              Provider.of<User>(context, listen: false).email) {
            setState(() {
              chatUsersListController.chatUsers.add(User.fromJson(user));
            });
          }
        }
      }
      // socket.close();
    });
  }

  @override
  void dispose() {
    // socket.disconnect();
    super.dispose();
  }

  void socketServer() {
    try {
      //Configure socket Transport
      // socket = io(generalUrl, <String, dynamic>{
      //   "transports": ["websocket"],
      //   'autoConnect': false,
      //   // 'forceNew': true
      // });
      socket = io(
          generalUrl,
          OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
              .build());
      socket.connect();
      socket.on('connect', (data) => print('Connected:' + socket.id!));
      socket.on('connect_error',
          (error) => print('Connnection Error:' + error.message.toString()));
      socket.on('error', (error) => print('Error:' + error.message.toString()));
    } catch (e) {
      print(e.toString());
    }
  }

  void getUsers() {
    socket.emit('_getUsers', {'senderEmail': 'arinzehill@gmail.com'});
    socket.on('_allUsers', (allUsers) {
      // print(allUsers);
      chatUsersListController.chatUsers.clear();

      for (var user in allUsers) {
        // users.add(_users);
        if (mounted) {
          if (user['email'] !=
              Provider.of<User>(context, listen: false).email) {
            setState(() {
              chatUsersListController.chatUsers.add(User.fromJson(user));
            });
          }
        }
      }
      // socket.close();
    });
  }

  List<String> imgUrl = [
    "assets/images/glory.png",
    "assets/images/GUC.jpeg",
    "assets/images/glory.png",
    "assets/images/green native.png",
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int empty = 0;
    print('chatUsersListController.chatUsers.length');
    print(chatUsersListController.chatUsers.length);

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppMenuBar(title: 'Chats'),
      body: SafeArea(
        child: Stack(children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              getUsers();
            },
            child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: CustomSliverDelegate(
                  expandedHeight: 129,
                  chatUsersListController: chatUsersListController,
                  alignment: const Alignment(0.0, 0.9),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.buildText(title: 'Messages'),
                      chatUsersListController.chatUsers.isEmpty
                          ? ListView.builder(
                              itemCount: 5,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildSkeleton(context);
                              })
                          : Obx(
                              () => ListView.builder(
                                itemCount:
                                    chatUsersListController.chatUsers.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (chatUsersListController
                                      .chatUsers.isNotEmpty) {
                                    return const Chat().buildNoChats(
                                        "have not started any conversation",
                                        size);
                                  } else {
                                    return ChatListWidget(
                                      socket: socket,
                                      userId: chatUsersListController
                                          .chatUsers[index].id,
                                      clickedEmail: chatUsersListController
                                          .chatUsers[index].email,
                                      name: chatUsersListController
                                          .chatUsers[index].fullName,
                                      messageText: chatUsersListController
                                          .chatUsers[index].email,
                                      imageUrl: imgUrl[index],
                                      // time: users[index].createdAt,
                                      isMessageRead: (index == 0 || index == 3)
                                          ? true
                                          : false,
                                      time: '',
                                    );
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }

  Wrap buildSkeleton(context) {
    return Wrap(children: [
      const Skeleton(width: 70, height: 70),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(
            width: size(context).width * 0.54,
          ),
          const SizedBox(height: 5),
          Skeleton(
            width: size(context).width * 0.4,
          ),
          // Skeleton(width: 80, height: 12),
        ],
      ),
    ]);
  }
}
