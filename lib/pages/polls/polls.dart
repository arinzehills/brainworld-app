import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/polls/add_poll.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Polls extends StatefulWidget {
  const Polls({Key? key}) : super(key: key);

  @override
  State<Polls> createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: MyAppMenuBar(title: 'Polls'),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      height: 230,
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                              colors: BrainWorldColors.mysocialblueGradient,
                              begin: Alignment.topCenter)),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(-1, 0),
                    child: ProfileUserWidget(
                      userId: '635f29b3ef13b39831cb7c4c',
                      isUserSubtitle: true,
                      comment: 'course.title',
                      subTitle: 'course.postedOn',
                    ),
                  )
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            MyNavigate.navigatejustpush(const AddPoll(), context);
          },
          backgroundColor: Colors.transparent,
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(15),
            child: const Icon(IconlyBold.paper_plus),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: myblueGradientTransparent)),
          ),
        ));
  }
}
