import 'package:brainworld/components/my_cachednetwork_image.dart';
import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class ProfileUserWidget extends StatefulWidget {
  const ProfileUserWidget(
      {Key? key,
      required this.userId,
      this.comment,
      this.subTitle,
      this.imageUrl,
      this.imageHeight,
      this.imageWidth,
      this.headerFontSize = 17,
      this.containerWidthRatio = 0.85,
      this.skeltonWidth,
      this.tileGap,
      this.subTitleColor,
      this.isUtilityType = false,
      this.isCircular = true,
      this.isUserSubtitle = false,
      this.withGapBwText = false,
      this.showbgColor = true})
      : super(key: key);
  final String userId;
  final String? comment;
  final String? subTitle;
  final subTitleColor;
  final bool isCircular;
  final String? imageUrl;
  final containerWidthRatio;
  final double? imageHeight;
  final double? tileGap;
  final double? imageWidth;
  final double? skeltonWidth;
  final double? headerFontSize;
  final bool isUtilityType;
  final bool isUserSubtitle;
  final bool showbgColor;
  final bool withGapBwText;

  @override
  State<ProfileUserWidget> createState() => _ProfileUserWidgetState();
}

class _ProfileUserWidgetState extends State<ProfileUserWidget> {
  late User user;
  bool loading = false;
  @override
  void initState() {
    print(widget.userId);
    _getUserFromNet();
  }

  _getUserFromNet() async {
    setState(() => {loading = true});
    Future.delayed(const Duration(seconds: 4));
    var value = await AuthService().getAUser(widget.userId);
    setState(() => user = value);
    setState(() => {loading = false});
  }

  @override
  Widget build(BuildContext context) {
    print(loading);
    return Padding(
      padding: const EdgeInsets.only(
        top: 0.6,
        bottom: 0.9,
      ),
      child: Container(
        // color: Colors.red,
        width: size(context).width * widget.containerWidthRatio,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: loading
              ? null
              : widget.showbgColor
                  ? Colors.black.withOpacity(0.01)
                  : null,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: _buildProfile(loading),
      ),
    );
  }

  Widget _buildProfile(loading) => loading
      ? Wrap(children: [
          Skeleton(
              width: widget.skeltonWidth ?? 65,
              height: widget.skeltonWidth ?? 65),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(
                width: size(context).width * 0.51,
              ),
              Skeleton(
                width: size(context).width * 0.4,
              ),
              widget.skeltonWidth == null
                  ? const Skeleton(width: 80, height: 12)
                  : const SizedBox(),
            ],
          ),
        ])
      : ListTile(
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(width: 0.5, color: myhomepageBlue),
          // ),
          horizontalTitleGap: widget.tileGap,
          leading: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.isCircular ? 50 : 10)),
              child: MyCachedNetworkImage(
                isProfile: true,
                height: widget.imageHeight != null
                    ? widget.imageHeight
                    : widget.isUtilityType
                        ? 35
                        : 50,
                width: widget.imageWidth != null
                    ? widget.imageWidth
                    : widget.isUtilityType
                        ? 35
                        : 50,
                imgUrl: widget.imageUrl ??
                    user.profilePicture ??
                    'https://res.cloudinary.com/djsk1t9zp/image/upload/v1666397804/Books/haqv1lanbute2lb55w69.png',
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.comment ?? user.fullName,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: widget.headerFontSize != 17
                        ? widget.headerFontSize
                        : 14),
              ),
              SizedBox(height: widget.withGapBwText ? 10 : null),
              Text(
                (widget.isUserSubtitle
                    ? '${user.fullName}, ${widget.subTitle}'
                    : widget.subTitle ?? 'February 21, 2022'),
                style: TextStyle(
                    color:
                        widget.subTitleColor ?? BrainWorldColors.textGreyColor,
                    fontSize: 13),
              ),
            ],
          ),
        );
}
