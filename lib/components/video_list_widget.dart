import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:flutter/material.dart';

class VideoListWidget extends StatelessWidget {
 const VideoListWidget(
      {Key? key,
      required this.course,
      this.video,
      this.index,
      this.subscribers})
      : super(key: key);
  final PostsModel course;
  final String? video;
  final int? subscribers;
  final int? index;
  @override
  Widget build(BuildContext context) {
    print('video');
    print(index);
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
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
          ],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        margin: const EdgeInsets.only(top: 0, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size(context).width * 0.36,
              height: 70,
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset('assets/images/womanwithlaptop.jpeg'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size(context).width * 0.55,
                  // color: Colors.red,
                  child: Text(
                    course.subTitles[index!],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ProfileUserWidget(
                  userId: course.userId!,
                  // isUtilityType: true,
                  tileGap: 0,
                  imageHeight: 30,
                  imageWidth: 30,
                  headerFontSize: 10,
                  subTitle: '${subscribers.toString()} subscribers',
                  containerWidthRatio: 0.53,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
