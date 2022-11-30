import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/fullresourcepage/full_photo_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../themes/themes.dart';

class MyCachedNetworkImage extends StatefulWidget {
  final String? imgUrl;
  final double? height;
  final double? width;
  final bool isProfile;
  const MyCachedNetworkImage(
      {Key? key, this.imgUrl, this.height, this.width, this.isProfile = false})
      : super(key: key);

  @override
  State<MyCachedNetworkImage> createState() => _MyCachedNetworkImageState();
}

class _MyCachedNetworkImageState extends State<MyCachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhotoPage(
              url: widget.imgUrl!,
            ),
          ),
        );
      },
      child: CachedNetworkImage(
        width: widget.height ?? 120,
        height: widget.width ?? 100,
        fit: BoxFit.cover,
        imageUrl: widget.imgUrl ??
            "https://res.cloudinary.com/djsk1t9zp/image/upload/v1666397804/Books/haqv1lanbute2lb55w69.png",
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
              strokeWidth: 5,
              color: BrainWorldColors.myhomepageBlue,
              value: downloadProgress.progress),
        ),
        errorWidget: (context, url, error) => Container(
          color: widget.isProfile ? Colors.black.withOpacity(0.04) : null,
          child: Icon(
            widget.isProfile ? IconlyBold.profile : Icons.error,
            size: widget.isProfile ? null : 50,
            color: widget.isProfile ? BrainWorldColors.myhomepageBlue : Colors.red,
          ),
        ),
      ),
    );
  }
}
