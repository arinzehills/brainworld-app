// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field_decoration.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/pages/upload/course/future_drop_down.dart';
import 'package:brainworld/pages/upload/course/model/course.dart';
import 'package:brainworld/pages/upload/course/upload_course.dart';
import 'package:brainworld/themes/themes.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:path/path.dart' as Path;

class UploadCourseInfo extends StatefulWidget {
  const UploadCourseInfo({Key? key}) : super(key: key);

  @override
  _UploadCourseInfoState createState() => _UploadCourseInfoState();
}

class _UploadCourseInfoState extends State<UploadCourseInfo> {
  // late final File? imagefile;
  // late final File? videofile;
  File? file;
  File? video;

  String packageDropdownValue = 'Select package';
  String packageError = '';
  String dropdownError = '';
  String error = '';
  String imageUrl = '';
  List<File>? files = [];
  List<String> filenames = [];
  String title = '';
  String description = '';
  String requirements = '';
  String price = '';
  String tag = '';
  //collecct the arrays of sub-titles
  //  File? video;
  String selectCategory = 'Select Category';
  bool showPackagePrice = false; //this shows the form field to enter price
  final _formKey = GlobalKey<FormState>();
  bool _multiPick = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String videoname = video != null
        ? Path.basename(video!.path)
        : 'Course introductory  Video(required)';
    //  final String videoname='Add Intro Video(s)(optional)';
    String filename = '';
    if (_multiPick) {
      if (files == null) {
        setState(() {
          filename = 'Add Course materials/Files(s)(optional)';
        });
      } else {
        String filenames = '';
        files!.forEach((file) {
          final fileName = Path.basename(file.path);
          filenames = filenames + fileName + ' /';
          print('filenames2 ' + filenames);
        });
        setState(() {
          filename = filenames;
        });
      }
    } else {
      setState(() {
        filename =
            file != null ? Path.basename(file!.path) : 'Add Files(s)(optional)';
      });
    }
    if (packageDropdownValue == 'paid') {
      setState(() {
        showPackagePrice = true;
      });
    } else {
      setState(() {
        showPackagePrice = false;
      });
    }
    Widget errorWidget(error) => Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            error,
            style: TextStyle(color: Colors.red),
          ),
        );
    return Scaffold(
      drawer: MyDrawer(),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
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
                              'ADD COURSE INFORMATION',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18).copyWith(
                        bottom: 130.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureDropDown(
                                selectedValue: selectCategory,
                                onChanged: (val) {
                                  setState(() => {selectCategory = val!});
                                },
                              ),
                              errorWidget(dropdownError),
                              packageType(),
                              errorWidget(packageError),
                              showPackagePrice == true
                                  ? Container(
                                      child: TextFormField(
                                        // validator: (val)=> val!.length < 6 ? 'Enter a valid password' : null,
                                        decoration: MyTextFieldDecoration
                                            .textFieldDecoration(
                                          hintText: 'Price (NGN)',
                                        ),
                                        onChanged: (val) {
                                          setState(() => price = val);
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter course title'
                                      : null,
                                  decoration:
                                      MyTextFieldDecoration.textFieldDecoration(
                                          hintText: 'Enter course title'),
                                  onChanged: (val) {
                                    setState(() => title = val);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  readOnly: true,
                                  // validator: (val)=> val!.length < 6 ? 'Enter a valid password' : null,
                                  decoration:
                                      MyTextFieldDecoration.textFieldDecoration(
                                    clickIcon: selectVideo,
                                    icon: IconlyBold.video,
                                    hintText: videoname,
                                  ),
                                  onChanged: (val) {
                                    // setState(() =>password=val);
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  readOnly: true,
                                  // validator: (val)=> val!.length < 6 ? 'Enter a valid password' : null,
                                  decoration:
                                      MyTextFieldDecoration.textFieldDecoration(
                                          clickIcon: selectFile,
                                          icon: IconlyBold.paper_plus,
                                          hintText: filename),
                                  onChanged: (val) {
                                    // setState(() =>password=val);
                                  },
                                ),
                              ),

                              SwitchListTile.adaptive(
                                title: Text('Pick multiple files',
                                    textAlign: TextAlign.left),
                                onChanged: ((bool value) =>
                                    setState(() => _multiPick = value)),
                                value: _multiPick,
                              ),

                              errorWidget(error),
                              Container(
                                child: TextFormField(
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter Brief Description *'
                                      : null,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  decoration:
                                      MyTextFieldDecoration.textFieldDecoration(
                                          hintText: 'Course Description'),
                                  onChanged: (val) {
                                    setState(() => description = val);
                                  },
                                ),
                              ),

                              //course requirement
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter Brief requirements *'
                                      : null,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  decoration:
                                      MyTextFieldDecoration.textFieldDecoration(
                                          hintText: 'Course requirements'),
                                  onChanged: (val) {
                                    setState(() => requirements = val);
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.8),
                child: Center(
                    child: MyButton(
                  placeHolder: 'CONTINUE',
                  isGradientButton: true,
                  gradientColors: BrainWorldColors.myblueGradient,
                  pressed: () {
                    var totalError = dropdownError + packageError + error;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        error = '';
                      });
                      if (packageDropdownValue == 'Select package') {
                        //no package seleceted
                        setState(() {
                          packageError = 'Please select your package';
                        });
                      } else {
                        setState(() {
                          packageError = '';
                        });
                      }
                      if (selectCategory == 'Select Category') {
                        //no package seleceted
                        setState(() {
                          dropdownError = 'Please select a category';
                        });
                      } else {
                        setState(() {
                          dropdownError = '';
                        });
                        if (videoname ==
                            'Course introductory  Video(required)') {
                          setState((() => error = 'select a video'));
                        }
                        if (totalError.isEmpty) {
                          Course course = Course(
                              usersid: '',
                              price: price == '' ? '0' : price,
                              category: selectCategory,
                              package: packageDropdownValue,
                              courseTitle: title,
                              description: description,
                              requirements: requirements,
                              video: video!,
                              filenames: filenames,
                              files: files!);

                          MyNavigate.navigatejustpush(
                              UploadCourse(
                                courseinfo: course,
                                files: files,
                              ),
                              context);
                          setState(() {});
                        } else {
                          print('there is total error:' + totalError);
                        }
                      }
                    } else {
                      setState(() {
                        error = 'Please enter missing inputs';
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Icon(
                      IconlyBold.arrow_right,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )),
              ))
        ]),
      ),
    );
  }

  Widget packageType() {
    return Padding(
      padding: EdgeInsets.all(0.0).copyWith(top: 2, bottom: 2),
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(25)),
        child: DropdownButton<String>(
          value: packageDropdownValue,
          icon: const Icon(
            Icons.expand_more,
            color: Colors.grey,
          ),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          style: const TextStyle(color: Colors.grey),
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              packageDropdownValue = newValue!;
            });
          },
          items: <String>['Select package', 'free', 'paid']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future selectFile() async {
    setState(() {
      filenames.clear();
    });
    if (_multiPick) {
      final result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf', 'doc'],
          allowMultiple: true,
          type: FileType.custom);
      setState(() => files = result!.paths.map((path) => File(path!)).toList());
      files!.forEach((file) {
        final fileName = Path.basename(file.path);
        setState(() {
          filenames.add(fileName);
        });
        print('filenames2 ' + filenames.toString());
      });
    } else {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['pdf', 'doc']);
      if (result == null) return;
      final path = result.files.single.path!;

      setState(() {
        file = new File(path);
      });

      print('file ' + file!.toString());
      final fileName = Path.basename(file!.path);

      final fileExtension = Path.extension(file!.path);
      // fileType.add('fileExtension '+fileExtension);
      setState(() {
        filenames.add(fileName);
        files = [file!];
      });
    }

    print('documentnames ' + filenames.toString());
  }

  Future selectVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => video = new File(path));
    print(video);
    // final fileName = Path.basename(video!.path);
  }
}
