// import 'package:brainworld/models/Course_tile.dart';

import 'package:brainworld/components/utilities_widgets/radial_gradient.dart';
import 'package:brainworld/models/course_model.dart';
import 'package:brainworld/pages/upload/course/model/course_tile.dart';
import 'package:flutter/material.dart';

class CourseTilePage extends StatelessWidget {
  final Course? course;
  final List<CourseTile> courseContents;
  final Function(String)? onTap;

  CourseTilePage(
      {Key? key, this.course, this.onTap, this.courseContents = const []})
      : super(key: key);

  final courseTile2 = <CourseTile>[];
  @override
  Widget build(BuildContext context) {
    // courseTitles.forEach((title) => {
    //       videoNames.forEach((name) => CourseTile2
    //           .add(CourseTile(title: title, tiles: [CourseTile(title: name)])))
    //       // CourseTile2.add(CourseTile(title: title))
    //     });
    // var myMap = course.subTitles.asMap().entries.map((entry) {
    //   CourseTile2.add(CourseTile(
    //       title: entry.value,
    //       tiles: [CourseTile(title: course.videonames[entry.key])]));

    //   return CourseTile2;
    // });
    // print(myMap);
    // videoNames.forEach(
    //     (name) => CourseTile2.add(CourseTile(tiles: [CourseTile(title: name)])));
    // print(CourseTile2);

    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: courseContents
          .map((tile) => CourseTileWidget(
                tile: tile,
                onTap: onTap,
              ))
          .toList(),
    );
  }
}

class CourseTileWidget extends StatelessWidget {
  final CourseTile? tile;
  final Function(String)? onTap;
final  Icon? icon;
 const CourseTileWidget({Key? key, this.tile, this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = tile!.title;
    final tiles = tile!.tiles;

    if (tiles.isEmpty) {
      return ListTile(
        title: Text(title),
        leading: const RadiantGradientMask(
          child: Icon(
            Icons.video_library,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return ExpansionTile(
        title: Text(title),
        children: tiles
            .map((tile) => GestureDetector(
                  onTap: () {
                    var title = tile.title;
                    onTap!(title);
                  },
                  child: CourseTileWidget(
                    tile: tile,
                    icon: const Icon(Icons.video_library),
                  ),
                ))
            .toList(),
      );
    }
  }
}
