import 'dart:convert';
import 'dart:io';
import 'package:brainworld/themes/themes.dart';
import 'package:path/path.dart' as Path;

import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/radial_gradient.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/models/posts_model.dart';
import 'package:brainworld/services/post_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
// import 'package:share/share.dart';

class AddPost extends StatefulWidget {
  final String? docid;
  final int noteCount;
  final String? title;
  final String? decription;
  const AddPost(
      {Key? key,
      this.docid,
      required this.noteCount,
      this.title,
      this.decription})
      : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String error = '';
  File? image;
  String imagename = '';
  bool loading = false;

  Future popUp(uid, docid) {
    int count = 0;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          height: 172,
          child: Center(
            child: Column(
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 17.0, top: 9),
                  child: Text(
                    'Confirm Delete?',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Are you sure you want to delete?',
                    style: TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 45,
                      child: RaisedButton(
                        child: const Text(
                          'No',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        color: BrainWorldColors.myhomepageBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        onPressed: () => {
                          // status==true ? _emailSuccess(context) : _emailFailure(context)
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: RaisedButton(
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        onPressed: () => {
                          // Navigator.of(context).popUntil((_) => count++ >= 2),
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String title = '';
  String caption = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              IconlyBold.arrow_left,
              color: BrainWorldColors.myhomepageLightBlue,
            ),
          ),
          elevation: 0,
          title: const Text(
            'Add Post',
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: BrainWorldColors.myhomepageBlue,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                _showModalBottomSheet(context, user.id, widget.docid);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/brainworld-logo.png",
                          height: 90,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          // height: 46,
                          child: TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'Enter the title of your post'
                                : null,
                            initialValue:
                                widget.docid == null ? null : widget.title,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              fillColor: Colors.white,
                              hintText: 'Title',
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
                              setState(() => title = val);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: TextFormField(
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter a caption' : null,
                              keyboardType: TextInputType.multiline,
                              initialValue: widget.docid == null
                                  ? null
                                  : widget.decription,
                              maxLines: image == null ? 15 : 4,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Enter caption...',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(23.0),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => caption = val);
                              },
                            ),
                          ),
                        ),
                        image == null
                            ? SizedBox()
                            : Image.file(
                                image!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: const RadiantGradientMask(
                                    child: Icon(
                                      IconlyBold.image,
                                      color:
                                          BrainWorldColors.myhomepageLightBlue,
                                      size: 39.83,
                                    ),
                                  ),
                                  tooltip: 'Add Picture',
                                  onPressed: selectImage),
                              MyButton(
                                placeHolder: 'save post',
                                height: 45,
                                isGradientButton: true,
                                loadingState: loading,
                                isOval: true,
                                gradientColors: myOrangeGradientTransparent,
                                widthRatio: 0.40,
                                pressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    PostsModel post = PostsModel(
                                        title: title,
                                        caption: caption,
                                        image: image);
                                    loadingStatus(context, 'uploading...');
                                    setState(() => loading = true);
                                    var res = await PostsService.addPost(post);
                                    var response = json.decode(res.body);
                                    print('res.body');
                                    print(res.body);
                                    if (response['success'] == true) {
                                      snackBar(BottomNavigation(), context,
                                          'Post added successfully');
                                    } else {
                                      setState(() => loading = false);
                                      setState(
                                          () => error = response['message']);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                ))));
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => image = new File(path));

    final bookCoverName = Path.basename(image!.path);
    setState(() {
      imagename = bookCoverName;
    });
    print('book names ' + bookCoverName);

    // final fileExtension = Path.extension(file!.path);
  }

  void _showModalBottomSheet(context, uid, docid) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: GradientText(
                        'More options',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        gradient: LinearGradient(
                          colors: [
                            BrainWorldColors.myhomepageBlue,
                            BrainWorldColors.myhomepageLightBlue
                          ],
                        ),
                      ),
                    ),
                    RadiantGradientMask(
                      child: IconButton(
                        icon: const Icon(
                          IconlyBold.close_square,
                          color: BrainWorldColors.myhomepageBlue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                    child: Row(
                      children: [
                        IconButton(
                          icon: const RadiantGradientMask(
                            child: Icon(
                              Icons.cancel,
                              color: BrainWorldColors.myhomepageLightBlue,
                              size: 19.83,
                            ),
                          ),
                          tooltip: 'cancel',
                          onPressed: () {},
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 13.0),
                          child: Text(
                            'Cancel changes',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.docid != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: GestureDetector(
                      onTap: () {
                        print('deleted');
                        Navigator.pop(context);
                        popUp(uid, docid);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(left: 12),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 19.83,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 13.0),
                              child: Text(
                                'Delete Note',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ]);
        });
  }
}
