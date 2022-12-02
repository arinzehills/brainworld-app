import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/pages/videopage/network_player.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final String videoName;
  final String videoUrl;
  const VideoPage({Key? key, required this.videoName, required this.videoUrl})
      : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: BrainWorldColors.myhomepageBlue,
        leading: IconButton(
          onPressed: () => {_scaffoldKey.currentState!.openDrawer()},
          icon: const ImageIcon(
            AssetImage('assets/menu_white.png'),
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NetworkPlayerWidget(
              videoName: widget.videoName,
              videoUrl: widget.videoUrl,
            ),
          ],
        ),
      ),
    );
  }
}
