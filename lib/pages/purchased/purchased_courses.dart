import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_cachednetwork_image.dart';
import 'package:brainworld/components/no_items_widget.dart';
import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/components/utilities_widgets/url_to_readable.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/services/order_service.dart';
import 'package:flutter/material.dart';

class PurchasedCourses extends StatefulWidget {
  const PurchasedCourses({Key? key}) : super(key: key);

  @override
  State<PurchasedCourses> createState() => _PurchasedCoursesState();
}

class _PurchasedCoursesState extends State<PurchasedCourses> {
  bool noitems = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostsModel>>(
        future: OrderService.getUserPurchasedCourses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //when is loading
            return buildLoading(context);
          }
          if (snapshot.data!.length == 0) {
            return NoItemsWidget();
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var course = snapshot.data![index];
                print(UrlToReadable.urlToReadableURL(course.videoURL!, '.png'));
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                                colors: mysocialblueGradient,
                                begin: Alignment.topCenter)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: MyCachedNetworkImage(
                              imgUrl: UrlToReadable.urlToReadableURL(
                                  course.videoURL!, '.png')),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-1, 0),
                      child: ProfileUserWidget(
                        userId: course.user_id!,
                        isUserSubtitle: true,
                        comment: course.title,
                        subTitle: course.postedOn,
                      ),
                    )
                  ],
                );
              });
        });
  }

  Column buildLoading(BuildContext context) {
    return Column(
      children: [
        Skeleton(
          height: 230,
        ),
        Row(
          children: [
            Skeleton(
              height: 50,
              width: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  width: size(context).width * 0.6,
                ),
                Skeleton(
                  width: 70,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
