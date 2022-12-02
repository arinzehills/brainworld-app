import 'package:brainworld/components/course_tile.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/upload/post_detail.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _logger = Logger();

  PostsController chatUsersListController = PostsController();
  bool loading = false;
  late Socket socket;
  String commenttoShow = '';
  // List<PostsModel> _postData = [];
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    // var userId = Provider.of<User>(context, listen: false).id;
    super.initState();
    socketServer();
    getPostList();
  }

  void getPostList() {
    socket.emit('postReaction', {
      "postReaction": {"reactionType": 'none', "pageType": 'home'}
    });
    socket.on('getAllPost', (allPosts) {
      chatUsersListController.allPost.clear();
      _logger.d(allPosts['message']);
      for (var post in allPosts['posts']) {
        setStateIfMounted(() {
          chatUsersListController.allPost.add(PostsModel.fromJson(post));
        });
      }
    });
  }

  void socketServer() {
    try {
      //Configure socket Transport
      socket = io(generalUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      socket.on('connect', (data) => _logger.d('Connected:' + socket.id!));
      socket.on(
          'connect_error',
          (error) =>
              _logger.d('Connnection Error:' + error.message.toString()));
      socket.on(
          'error', (error) => _logger.d('Error:' + error.message.toString()));
    } catch (e) {
      _logger.d(e.toString());
    }
  }

  @override
  void dispose() {
    // socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('users');
    // print(chatUsersListController.allPost.length);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppMenuBar(
        title: widget.title,
      ),

      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          getPostList();
          Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              msg: "Post updated",
              backgroundColor: BrainWorldColors.myhomepageBlue,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            color: const Color(0xffF7F7F7),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(
                  () => chatUsersListController.allPost.isNotEmpty
                      ? ListView.builder(
                          itemCount: chatUsersListController.allPost.length,
                          shrinkWrap: true,
                          reverse: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(Obx(() => PostDetail(
                                      socket: socket,
                                      post: chatUsersListController
                                          .allPost[index],
                                    )));
                              },
                              child: Obx(
                                () => CoursesTile(
                                  // post: snapshot.data[index],
                                  socket: socket,
                                  post: chatUsersListController.allPost[index],
                                  courseIndex: index,
                                  postsController: chatUsersListController,
                                ),
                              ),
                            );
                          },
                        )
                      : const Loading(),
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
