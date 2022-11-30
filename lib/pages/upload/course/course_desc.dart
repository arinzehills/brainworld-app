// ignore_for_file: prefer_const_constructors

import 'package:brainworld/components/course_tile_page.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/expandable_text_widget.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/components/utilities_widgets/radial_gradient.dart';
import 'package:brainworld/components/utilities_widgets/url_to_readable.dart';
import 'package:brainworld/components/video_list_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/controllers/chat_controller.dart';
import 'package:brainworld/controllers/course_controller.dart';
import 'package:brainworld/controllers/post_controller.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/chat_detail.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:brainworld/pages/homepage/components/reactionicon.dart';
import 'package:brainworld/pages/upload/course/model/course.dart';
import 'package:brainworld/pages/upload/course/model/course_tile.dart';
import 'package:brainworld/pages/videopage/network_player.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class CourseDescPage extends StatefulWidget {
  CourseDescPage({
    Key? key,
    required this.course,
    required this.socket,
  }) : super(key: key);
  final PostsModel course;
  Socket socket;
  @override
  _CourseDescPageState createState() => _CourseDescPageState();
}

class UserData {
  String title;
  IconData? leading;
  UserData({required this.title, this.leading});
}

class _CourseDescPageState extends State<CourseDescPage> {
  List<UserData> title = [
    UserData(title: 'title', leading: Icons.person),
    UserData(title: 'phone', leading: Icons.mobile_friendly),
    UserData(title: 'email', leading: Icons.email_outlined),
    UserData(title: 'address', leading: Icons.location_on),
  ];
  final cartController = Get.put(CartService());
  late Socket socket;
  bool loadingName = false;
  PostsController chatUsersListController = PostsController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // socketServer();
    getPostList();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getPostList() {
    print('allPosts[]');

    widget.socket.emit('postReaction', {
      "postReaction": {
        "reactionType": 'none',
        "user_id": widget.course.user_id,
      }
    });
    widget.socket.on('getAllPost', (allPosts) {
      print('oga why now, why');
      print(allPosts['subscribers']);
      // for (var post in allPosts['subscribers']) {
      var sub = allPosts['subscribers'] as List;
      setStateIfMounted(() {
        // chatUsersListController.allPost.add(PostsModel.fromJson(post));
        chatUsersListController.subscribers.value = sub;
      });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    print('subscribers');
    print(chatUsersListController.subscribers.value);
    Size size = MediaQuery.of(context).size;
    final courseTile2 = <CourseTile>[];

    // var myMap = widget.course.subTitles.asMap().entries.map((entry) {
    //   // courseTile2.add(CourseTile(
    //   //     title: entry.value,
    //   //     tiles: [CourseTile(title: widget.course.video[entry.key])]));

    //   return courseTile2;
    // });
    print(widget.course.videoURL);
    print(UrlToReadable.videoUrlToReadableURL(widget.course.videoURL!, '.mp4'));
    return Scaffold(
      drawer: MyDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: myhomepageBlue,
        leading: IconButton(
            onPressed: () => {_scaffoldKey.currentState!.openDrawer()},
            icon: SvgPicture.asset(
              'assets/svg/menuicon.svg',
              // height: 100,
              color: Colors.white,
            )),
        actions: [
          // LeftCartWidget(cartController: cartController),
          IconButton(
            icon: Icon(
              IconlyBold.more_circle,
              color: Colors.white,
            ),
            tooltip: 'Show Snackbar',
            onPressed: () {
              // showPurchaseBottomSheet(
              //     uid: widget.course.post_id,
              //     context: context,
              //     course: widget.course,
              //     cartController: cartController);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Column(
            children: [
              SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.course.videoURL != null
                            ? NetworkPlayerWidget(
                                videoName: 'Course preview Video',
                                videoUrl: UrlToReadable.videoUrlToReadableURL(
                                    widget.course.videoURL!, '.mp4'),
                              )
                            : Container(
                                width: double.infinity,
                                height: size.height * 0.4,
                                decoration: BoxDecoration(
                                  // color: Colors.,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/uploads_blue.png"),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 0.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ProfileUserWidget(
                                    userId: widget.course.user_id!,
                                    comment: toBeginningOfSentenceCase(
                                            widget.course.title) ??
                                        '',
                                    subTitle: widget.course.postedOn,
                                    showbgColor: true,
                                    containerWidthRatio: 0.807,
                                    // subTitle: ,
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      print('guy'),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ChangeNotifierProvider(
                                              create: (context) =>
                                                  ChatController(),
                                              child: ChatDetail(
                                                  sendersid: user.id,
                                                  clickeduserid:
                                                      widget.course.user_id!,
                                                  name: 'widget.name'),
                                            ),
                                          ))
                                    },
                                    child: Column(
                                      children: [
                                        RadiantGradientMask(
                                          child: SvgPicture.asset(
                                              'assets/svg/chatsbubble.svg',
                                              height: 20,
                                              fit: BoxFit.fill,
                                              color: iconsColor,
                                              semanticsLabel: 'A red up arrow'),
                                        ),
                                        Text('Message')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ExpandableTextWidget(
                                    text: widget.course.caption ?? ''),
                              ),
                              reactionRow(user),
                              buildText(
                                text: 'Course Contents',
                                isHeadline: true,
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    ProfileUserWidget(
                                      userId: widget.course.user_id!,
                                      isUtilityType: true,
                                      isUserSubtitle: true,
                                      comment: 'Course Instructor',
                                      containerWidthRatio: 0.7,
                                    ),
                                    Text(
                                        '${chatUsersListController.subscribers.length}  subscribers')
                                  ],
                                ),
                              ),
                              buildText(text: 'Requirements', isHeadline: true),
                              buildText(
                                text: widget.course.requirements ??
                                    'Requirements',
                              ),
                              buildText(
                                  text: 'Course materials/files',
                                  isSubHeadline: true),
                              widget.course.fileUrls!.length == 0
                                  ? buildText(
                                      text: 'No Files for this contents')
                                  : Column(
                                      children: [
                                        ListView.builder(
                                            itemCount:
                                                widget.course.fileUrls!.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return widget.course.fileUrls!
                                                          .length !=
                                                      0
                                                  ? buildText(
                                                      text:
                                                          'No Files for this contents')
                                                  : Column(
                                                      children: [
                                                        Card(
                                                          child: ListTile(
                                                            title: Text(widget
                                                                    .course
                                                                    .fileUrls![
                                                                index]),
                                                            //   leading:uploadData['filetype'][index]!='.pdf' ?  ImageIcon(
                                                            // AssetImage('assets/ms_word.png'),
                                                            //   size: 30,
                                                            //   color: Colors.blue,
                                                            // ) :
                                                            //  Icon(
                                                            //     Icons.picture_as_pdf ,
                                                            //       color: Colors.red,
                                                            //     ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            }),
                                      ],
                                    ),
                              ExpansionTile(
                                  title: buildText(
                                      text: 'Videos', isSubHeadline: true),
                                  children: widget.course.videoUrls!
                                      .map((video) => Obx(
                                            () => VideoListWidget(
                                                subscribers:
                                                    chatUsersListController
                                                        .subscribers.length,
                                                course: widget.course,
                                                video: video,
                                                index: widget.course.videoUrls!
                                                    .indexOf(video)),
                                          ))
                                      .toList())
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container reactionRow(
    User user,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
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
                iconUrl: 'assets/svg/thumbsup.svg',
                text: widget.course.likes!.length.toString(),
                onClick: () async {
                  reactOnPost(
                      widget.course.post_id, widget.course.user_id, 'like');
                },
              ),
              ReactionIcon(
                withMarginLeft: true,
                iconUrl: 'assets/svg/commenticon.svg',
                text: widget.course.comments!.length.toString(),
                onClick: () {},
              ),
            ],
          ),
          Row(
            children: [
              // Text(widget.post.likes!.length.toString()),

              MyButton(
                  widthRatio: 0.4,
                  height: 50,
                  withBorder:
                      chatUsersListController.subscribers.contains(user.id)
                          ? false
                          : true,
                  isGradientButton: true,
                  gradientColors: myOrangeGradientTransparent,
                  placeHolder:
                      chatUsersListController.subscribers.contains(user.id)
                          ? 'Subscribed'
                          : 'Subscribe',
                  pressed: () {
                    reactOnPost(widget.course.post_id, widget.course.user_id,
                        'subscribe');
                  }),
              SizedBox(
                width: 10,
              ),
              ReactionIcon(
                iconUrl: 'assets/svg/saveposticon.svg',
                iconHeight: 26,
                onClick: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> reactOnPost(postid, userid, reactionType) async {
    // FocusScope.of(context).unfocus(); //this unfocusses the keybaord
    var subscribers_id = Provider.of<User>(context, listen: false).id;

    var postReaction = {
      "reactionType": reactionType ?? 'like',
      "post_id": postid,
      "user_id": userid,
      "subscribers_id": subscribers_id
    };

    widget.socket.emit('postReaction', {
      "postReaction": postReaction,
    }); //sends data to back
  }

  Padding buildText(
      {text, bool isHeadline = false, bool isSubHeadline = false}) {
    return Padding(
      padding: isHeadline
          ? EdgeInsets.only(left: 8.0, top: 20)
          : EdgeInsets.all(10).copyWith(top: 15),
      child: isHeadline
          ? Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )
          : isSubHeadline
              ? Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : Text(text),
    );
  }
}
