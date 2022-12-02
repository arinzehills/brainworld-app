import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;
  final String? pageTitle;

  const FullPhotoPage({Key? key, required this.url, this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrainWorldColors.myhomepageBlue,
        title: Text(
          pageTitle ?? 'Full Photo',
          style: const TextStyle(color: BrainWorldColors.myhomepageLightBlue),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
