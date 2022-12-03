import 'dart:convert';
import 'dart:io';
import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/course_tile_page.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';

import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/upload/course/model/course.dart';
import 'package:brainworld/pages/upload/course/model/course_tile.dart';
import 'package:brainworld/services/course_service.dart';
import 'package:brainworld/themes/themes.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class UploadCourse extends StatefulWidget {
  final Course? courseinfo;
  final List<File>? files;
  final IconData? leading;
  const UploadCourse({Key? key, this.courseinfo, this.files, this.leading})
      : super(key: key);

  @override
  _UploadCourseState createState() => _UploadCourseState();
}

class UserData {}

class _UploadCourseState extends State<UploadCourse> {
  File? video;
  final List<File> videos = [];
  final coursescontents = <CourseTile>[];
  final List<String> videonames = [];
  List<String> videoURls = [];
  List<String> fileURls = [];
  final List<String> subtitles = [];
  String subTitle = '';
  String error = '';
  String videoURL = '';
  String videoname = 'Add a Video';
  bool showUploadBox = false;
  bool showaddContentWidget = false;

  bool loading = false;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => video = File(path));
    final fileName = Path.basename(video!.path);
    setState(() {
      videoname = fileName.split('.').first;
      videonames.add(fileName);
      // videos.add(video!);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future uploadCourse(uid, File? video) async {}

  addintoallarrays(coursename, subTitle) {
    coursescontents.add(
        CourseTile(title: subTitle, tiles: [CourseTile(title: coursename)]));
    subtitles.add(subTitle);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // var user = Provider().
    print('my videoswe ' + widget.files.toString());
    print('my videoswe ' + widget.files!.length.toString());
    print('widget.courseinfo!.videourl $videoURL');
    // print('widget.courseinfo!.video ${widget.courseinfo!.video}');
    return Scaffold(
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Builder(
              builder: (context) => Column(
                children: [
                  NormalCurveContainer(
                    size: size,
                    height: size.height * 0.17,
                    showDrawer: false,
                    containerRadius: 90,
                    widget: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: Column(
                          children: const [
                            ImageIcon(
                              AssetImage('assets/images/uploads_blue.png'),
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              'UPLOAD COURSE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //check if user has started adding course contents
                  coursescontents.isNotEmpty
                      ? CourseTilePage(
                          courseContents: coursescontents,
                        )
                      : noCourseContents(),
                  GestureDetector(
                      onTap: () {
                        // coursescontents.add(value)
                        print(showaddContentWidget);
                        if (showaddContentWidget == false) {
                          setState(() {
                            showaddContentWidget = true;
                          });
                        } else {
                          setState(() {
                            showaddContentWidget = false;
                          });
                        }
                        print(videos);
                      },
                      child: plusButton(coursescontents)),
                  //this widgets shows or hides if the user
                  //hits the plus button to add contents
                  showaddContentWidget == true
                      ? addCourseContents()
                      : const SizedBox()
                ],
              ),
            ),
          ),
          coursescontents.isEmpty || showaddContentWidget == true
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.8),
                    child: Center(
                        child: MyButton(
                      isGradientButton: true,
                      gradientColors: BrainWorldColors.myOrangeGradientTransparent,
                      placeHolder: 'UPLOAD',
                      pressed: () async {
                        setState(() => {loading = true});
                        var course = Course(
                            usersid: user(context).id,
                            courseTitle: widget.courseinfo!.courseTitle,
                            description: widget.courseinfo!.description,
                            requirements: widget.courseinfo!.requirements,
                            price: widget.courseinfo!.price,
                            category: widget.courseinfo!.category,
                            package: widget.courseinfo!.package,
                            videoURL: videoURL,
                            filenames: widget.courseinfo!.filenames,
                            files: widget.courseinfo!.files,
                            subTitles: subtitles,
                            video: widget.courseinfo!.video,
                            videos: videos);
                        print(course.usersid);
                        loadingStatus(context, 'adding post..');

                        var res = await CourseService().addCourse(course);
                        var response = json.decode(res.body);
                        print(response);
                        if (response['success'] == true) {
                          setState(() => loading = false);
                          snackBar(const BottomNavigation(), context,
                              'Post added successfully');
                        } else {
                          setState(() => loading = false);
                          setState(() => error = response['message']);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: ImageIcon(
                          AssetImage('assets/images/uploads_blue.png'),
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    )),
                  ))
        ]),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget addCourseContents() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Form(
            key: _formKey,
            child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.87,
                      height: 46,
                      child: TextFormField(
                        validator: (val) => val!.isEmpty ? 'Enter title' : null,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 0.2),
                          hintText: 'Title'
                              '(E.g Introduction to mathematics)',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: BrainWorldColors.myhomepageLightBlue,
                                width: 0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => subTitle = val);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.87,
                      height: 46,
                      child: TextFormField(
                        readOnly: true,
                        // validator: (val)=> val=='Add a Video' ? 'Please select a video' : null,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 0.2),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.video_library),
                              color: BrainWorldColors.myhomepageBlue,
                              onPressed: selectFile),
                          fillColor: Colors.white,
                          hintText: videoname,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: BrainWorldColors.myhomepageBlue,
                                width: 0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (val) {
                          // setState(() =>videoname=val);
                          // print('onchange');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyButton(
                          placeHolder: 'Add',
                          isOval: true,
                          widthRatio: 0.4,
                          gradientColors: BrainWorldColors.myblueGradientTransparent,
                          isGradientButton: true,
                          pressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (videoname == 'Add a Video') {
                                //no video seleceted
                                print(videoname + 'is add');
                                setState(() {
                                  error = 'Please select a video';
                                });
                              } else {
                                //if video is selected
                                addintoallarrays(videoname, subTitle);
                                videos.add(video!);
                                print(subtitles);
                                print('videonames ' + videonames.toString());
                                setState(() {
                                  error = '';
                                  showaddContentWidget = false;
                                  videoname = 'Add a Video';
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      );
  Widget noCourseContents() => Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 35),
        child: SizedBox(
          child: Center(
            child: Column(
              children: const [
                GradientText('No Contents for this Course yet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    gradient: LinearGradient(
                      colors: [
                        BrainWorldColors.myhomepageBlue,
                        BrainWorldColors.myhomepageLightBlue
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Start adding contents!',
                  style: TextStyle(color: Colors.amber, fontSize: 17),
                )
              ],
            ),
          ),
        ),
      );
  Widget plusButton(
    coursesContent,
  ) =>
      Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Row(
          mainAxisAlignment: coursesContent.isEmpty
              ? MainAxisAlignment.center
              : MainAxisAlignment.end,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      BrainWorldColors.myhomepageBlue,
                      BrainWorldColors.myhomepageLightBlue
                    ]),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: BrainWorldColors.myhomepageBlue.withOpacity(0.24),
                    // spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.white,
              )),
            ),
          ],
        ),
      );

  // Widget courseTileWidget()=>
  // Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: ListView(
  //     shrinkWrap: true,
  //      physics: ScrollPhysics(),
  //     children: coursescontents.map((course) =>
  //         CourseTileWidget(course:course,
  //         pressed: ()=>{
  //            coursescontents.remove(course.title)

  //         },
  //         ))
  //         .toList(),
  //   ),
  // );

}
