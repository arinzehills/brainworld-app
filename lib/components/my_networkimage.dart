import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/fullresourcepage/full_photo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class MyNetworkImage extends StatefulWidget {
  final double? height;
  final double? width;
  final String? imgUrl;
  const MyNetworkImage({Key? key, this.height, this.width, this.imgUrl})
      : super(key: key);

  @override
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
          child: CupertinoButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPhotoPage(
                url: widget.imgUrl ?? 'profilePhoto',
              ),
            ),
          );
        },
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Image.network(
              widget.imgUrl ?? '',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, object, stackTrace) {
                return Container(
                  color: Colors.white,
                  width: 75,
                  height: 75,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Icon(
                        IconlyBold.profile,
                        color: myhomepageBlue,
                      )),
                );
              },
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.white,
                  width: 90,
                  height: 90,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: myhomepageBlue,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      )),
    );
  }
}
