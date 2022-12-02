import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
final  bool? isFileVideo;
  final VideoPlayerController controller;

 const VideoWidget({Key? key, this.isFileVideo, required this.controller})
      : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) =>
      widget.controller != null && widget.controller.value.isInitialized
          ? Container(
              alignment: Alignment.topCenter,
              child: buildVideo(),
            )
          :const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayer(),
          Positioned.fill(child: basicOverlayWidget())
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller));

  Widget basicOverlayWidget() => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.controller.value.isPlaying
            ? widget.controller.pause()
            : widget.controller.play(),
        child: Stack(
          children: [
            buildPlay(),
            Positioned(bottom: 0, left: 0, right: 0, child: buildIndicator()),
          ],
        ),
      );
  Widget buildIndicator() =>
      VideoProgressIndicator(widget.controller, allowScrubbing: true);
  Widget buildPlay() => widget.controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
}
