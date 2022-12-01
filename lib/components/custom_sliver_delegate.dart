import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/controllers/chat_users_controller.dart';
import 'package:brainworld/pages/chats/chat.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconly/iconly.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  Widget?
      aligncontainerwidget; //the widget that is align/stacked at the top of the curve container
  ChatUsersController? chatUsersListController;

  String? searchHint;
  String? searchString;
  bool? showSearchButton;
  Function(String)? onTap; //this is for the horizontal categories widget
  Function(String)? onChanged; //this is for the search text field
  Alignment alignment;
  CustomSliverDelegate(
      {required this.expandedHeight,
      this.hideTitleWhenExpanded = true,
      this.aligncontainerwidget,
      this.searchHint,
      this.searchString,
      this.onChanged,
      this.chatUsersListController,
      this.showSearchButton,
      required this.alignment,
      this.onTap});

  List<String> imgUrl = [
    "assets/images/glory.png",
    "assets/images/GUC.jpeg",
    "assets/images/glory.png",
    "assets/images/green native.png",
  ];

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;

    Size size = MediaQuery.of(context).size;
    return
        // SizedBox(
        // height: expandedHeight + expandedHeight / 2,
        // child:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      print(chatUsersListController!.chatUsers.length);
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: textField(),
          ),
          Align(
            alignment: const Alignment(1.0, 0.9),
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 80,
                  right: 1,
                ),
                child: Wrap(
                  children: [
                    Chat().buildText(title: 'Quick Chat'),
                    SizedBox(
                        height: 90,
                        width: double.infinity,
                        child: chatUsersListController!.chatUsers.isEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return const Skeleton(
                                    width: 75,
                                  );
                                })
                            : Obx(
                                () => ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: chatUsersListController!
                                        .chatUsers.length,
                                    // shrinkWrap: true,
                                    //  padding: EdgeInsets.only(top: 10,bottom: 10),
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return chatUsersListController!
                                              .chatUsers.isEmpty
                                          ? Center(
                                              child: Chat().buildText(
                                                title:
                                                    "have not started any conversation",
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {},
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Container(
                                                    height: 0,
                                                    width: size.width * 0.20,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    19)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 30,
                                                              spreadRadius: 0,
                                                              offset:
                                                                  const Offset(
                                                                      5, 20))
                                                        ]),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            imgUrl[index],
                                                            height: 70,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                    }),
                              )),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent =>
      expandedHeight < 150 ? expandedHeight - 8 : expandedHeight - 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Container textField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Search here...',
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: BrainWorldColors.myhomepageBlue, width: 0.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(
              IconlyBold.search,
              color: BrainWorldColors.iconsColors,
            )),
      ),
    );
  }
}
