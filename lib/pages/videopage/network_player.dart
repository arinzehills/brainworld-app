import 'package:brainworld/pages/videopage/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkPlayerWidget extends StatefulWidget {
  final String videoName;
  final String videoUrl;
  final bool? showVideoName;
  final bool? autoPlay;
  const NetworkPlayerWidget(
      {Key? key,
      required this.videoName,
      this.showVideoName,
      this.autoPlay,
      required this.videoUrl})
      : super(key: key);

  @override
  State<NetworkPlayerWidget> createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) =>
          widget.autoPlay == false ? controller.pause() : controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          VideoWidget(
            controller: controller,
          ),
          widget.showVideoName == false
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        child: Text(
                          widget.videoName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (controller != null && controller.value.isInitialized)
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                icon: Icon(
                                  isMuted ? Icons.volume_off : Icons.volume_up,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    controller.setVolume(isMuted ? 1 : 0),
                              ),
                            ),
                            Text(isMuted ? 'unmute' : 'mute')
                          ],
                        )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
