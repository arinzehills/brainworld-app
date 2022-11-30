import 'dart:io';

import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/books_model.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/services/post_service.dart';
import 'package:brainworld/services/upload_service.dart';
import 'package:brainworld/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';

class AddToLocalLibray extends StatefulWidget {
  const AddToLocalLibray({
    Key? key,
  }) : super(key: key);

  @override
  State<AddToLocalLibray> createState() => _AddToLocalLibrayState();
}

class _AddToLocalLibrayState extends State<AddToLocalLibray> {
  String title = '';
  String category = '';
  final _formKey = GlobalKey<FormState>();
  File? file;

  double _progressValue = 0;
  int _progressPercentValue = 0;
  bool loading = false;
  String filename = 'Select book';
  String error = '';
  bool showUploadStatus = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        NormalCurveContainer(
          size: size,
          height: size.height * 0.21,
          showDrawer: false,
          containerRadius: 90,
          widget: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Center(
              child: Column(
                children: [
                  ImageIcon(
                    AssetImage('assets/images/uploads_blue.png'),
                    size: 60,
                    color: Colors.white,
                  ),
                  Text(
                    'UPLOAD TO BOOKS LIBRARY',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/librarybooks.png",
                      height: 170,
                    ),
                    buildText(text: 'Title'),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.87,
                      // height: 46,
                      padding: EdgeInsets.only(top: 2),
                      child: TextFormField(
                        validator: (val) => val!.isEmpty
                            ? 'Enter the title of your post'
                            : null,
                        decoration: textfielddecoration(hintText: 'Title'),
                        onChanged: (val) {
                          setState(() => title = val);
                        },
                      ),
                    ),
                    buildText(text: 'Category/Shelf'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.87,
                        // height: 46,
                        child: TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter the category/shelf that u want it to be'
                              : null,
                          decoration: textfielddecoration(hintText: 'Category'),
                          onChanged: (val) {
                            setState(() => category = val);
                          },
                        ),
                      ),
                    ),
                    buildText(text: 'Your book'),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.87,
                      height: 46,
                      child: TextFormField(
                        readOnly: true,
                        decoration: textfielddecoration(
                            clickIcon: selectFile, hintText: filename),
                        onChanged: (val) {
                          // setState(() =>nameoffile=val);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    showUploadStatus ? _buildUploadView() : SizedBox(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MyButton(
                        placeHolder: 'Upload',
                        height: 55,
                        isGradientButton: true,
                        isOval: true,
                        gradientColors: myOrangeGradientTransparent,
                        widthRatio: 0.40,
                        pressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              showUploadStatus = true;
                            });
                            BookModel book = BookModel(
                                category: category,
                                title: title,
                                filename: filename,
                                price: '');
                            UploadService().uploadToLocal(
                              book,
                              file!,
                            );
                          }
                        },
                      ),
                    ),
                  ]),
            )),
      ],
    )));
  }

  Widget _buildUploadView() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: EdgeInsets.only(top: 10),
              child: new Column(children: <Widget>[
                Text(
                  '$_progressPercentValue %',
                ),
              ])),
          Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: LinearProgressIndicator(value: _progressValue)),
        ]);
  }

  void _setUploadProgress(int sentBytes, int totalBytes) {
    double __progressValue =
        Util.remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);

    __progressValue = double.parse(__progressValue.toStringAsFixed(2));

    if (__progressValue != _progressValue)
      setState(() {
        _progressValue = __progressValue;
        _progressPercentValue = (_progressValue * 100.0).toInt();
      });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc']);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = new File(path));

    print('file ' + file!.toString());
    final fileName = Path.basename(file!.path);
    setState(() => filename = fileName);

    print('filenames ' + fileName);
  }

  InputDecoration textfielddecoration(
      {VoidCallback? clickIcon, icon, hintText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: Colors.white,
      suffixIcon: clickIcon != null
          ? IconButton(
              icon: Icon(icon ?? IconlyBold.paper_upload),
              color: myhomepageBlue,
              onPressed: clickIcon)
          : SizedBox(),
      hintText: hintText ?? 'hintTExt',
      hintStyle: TextStyle(
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: myhomepageLightBlue, width: 0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  buildText({text}) => Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 3),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: myhomepageBlue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      );
}
