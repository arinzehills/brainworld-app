import 'package:brainworld/components/profile_user_widget.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhiteCardListWidget extends StatelessWidget {
  const WhiteCardListWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Container(
        height: 92,
        padding: const EdgeInsets.only(left: 4, right: 16, top: 3, bottom: 10),
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
              userId: order.userId,
              // isUtilityType: true,
              comment: order.title,
              subTitle: order.orderOn,
              isCircular: false,
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
                  order.price,
                  style: const TextStyle(
                    fontSize: 13, color: BrainWorldColors.myhomepageBlue,
                    // fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                  ),
                ),
                Container(
                  height: 21,
                  width: 21,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: BrainWorldColors.myblueGradientTransparent,
                    ),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    order.orderType == 'course'
                        ? 'assets/svg/gragicon.svg'
                        : 'assets/svg/booksicon.svg',
                    height: 10,
                    // fit: BoxFit.fill,
                    color: Colors.white,
                  )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
