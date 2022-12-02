import 'dart:convert';
import 'dart:io';

import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field_decoration.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';

import '../../services/upload_service.dart';

class AddToBooks extends StatefulWidget {
  const AddToBooks({
    Key? key,
  }) : super(key: key);

  @override
  State<AddToBooks> createState() => _AddToBooksState();
}

class _AddToBooksState extends State<AddToBooks> {
  String title = '';
  String category = '';
  String price = '';
  final _formKey = GlobalKey<FormState>();
  File? file;
  File? bookCoverImage;

  bool loading = false;
  String filename = 'Select book';
  String imagename = 'Select image for book cover';
  String error = '';
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NormalCurveContainer(
              size: size,
              // showDrawer: true,
              height: size.height * 0.21,
              imageUrl: 'assets/svg/arrowback.svg',
              containerRadius: 90,
              widget: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Center(
                  child: Column(
                    children: const [
                      ImageIcon(
                        AssetImage('assets/images/uploads_blue.png'),
                        size: 56,
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
                        bookCoverImage == null
                            ? Image.asset(
                                "assets/images/librarybooks.png",
                                height: 120,
                              )
                            : Image.file(
                                bookCoverImage!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                        buildText(text: 'Title'),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          // height: 46,
                          padding: const EdgeInsets.only(top: 2),
                          child: TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'Enter the title of your book'
                                : null,
                            decoration:
                                MyTextFieldDecoration.textFieldDecoration(
                                    hintText: 'Enter title'),
                            onChanged: (val) {
                              setState(() => title = val);
                            },
                          ),
                        ),
                        buildText(text: 'Category'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.87,
                            // height: 46,
                            child: TextFormField(
                              validator: (val) => val!.isEmpty
                                  ? 'Enter the Category of your book'
                                  : null,
                              decoration:
                                  MyTextFieldDecoration.textFieldDecoration(
                                      hintText: 'Enter category'),
                              onChanged: (val) {
                                setState(() => category = val);
                              },
                            ),
                          ),
                        ),
                        buildText(text: 'Your price'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.87,
                            // height: 46,
                            child: TextFormField(
                              validator: (val) => val!.isEmpty
                                  ? 'Enter the price u wish to sell the book'
                                  : null,
                              decoration:
                                  MyTextFieldDecoration.textFieldDecoration(
                                      hintText: 'Enter price'),
                              onChanged: (val) {
                                setState(() => price = val);
                              },
                            ),
                          ),
                        ),
                        buildText(text: 'Book cover'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          height: 46,
                          child: TextFormField(
                            readOnly: true,
                            decoration:
                                MyTextFieldDecoration.textFieldDecoration(
                                    clickIcon: selectImage,
                                    icon: IconlyBold.image,
                                    hintText: imagename),
                            onChanged: (val) {
                              // setState(() =>nameoffile=val);
                            },
                          ),
                        ),
                        buildText(text: 'Your book'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          height: 46,
                          child: TextFormField(
                            readOnly: true,
                            decoration:
                                MyTextFieldDecoration.textFieldDecoration(
                                    clickIcon: selectFile, hintText: filename),
                            onChanged: (val) {
                              // setState(() =>nameoffile=val);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: MyButton(
                            placeHolder: 'Upload',
                            height: 55,
                            isGradientButton: true,
                            loadingState: loading,
                            isOval: true,
                            gradientColors:
                                BrainWorldColors.myOrangeGradientTransparent,
                            widthRatio: 0.40,
                            pressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);

                                BookModel book = BookModel(
                                    title: title,
                                    category: category,
                                    price: price,
                                    filename: filename);
                                var response = await UploadService().uploadBook(
                                    book, file!, bookCoverImage!.path);
                                var body = json.decode(response.body);
                                // print(body);
                                _logger.d(body['success']);
                                if (body['success']) {
                                  snackBar(
                                      const BottomNavigation(
                                        index: 4,
                                      ),
                                      context,
                                      body['message']);
                                } else {
                                  setState(() => loading = false);
                                  setState(() => error = body['message']);
                                }
                              }
                            },
                          ),
                        ),
                      ]),
                )),
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc', 'docx']);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    _logger.d('file ' + file!.toString());
    final fileName = Path.basename(file!.path);
    setState(() {
      filename = fileName;
    });
    _logger.d('filenames ' + fileName);
    final fileExtension = Path.extension(file!.path);
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => bookCoverImage = File(path));

    final bookCoverName = Path.basename(bookCoverImage!.path);
    setState(() {
      imagename = bookCoverName;
    });
    _logger.d('book names ' + bookCoverName);

    // final fileExtension = Path.extension(file!.path);
  }

  buildText({text}) => Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 3),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              color: BrainWorldColors.myhomepageBlue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      );
}
