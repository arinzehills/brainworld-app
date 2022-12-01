import 'dart:convert';
import 'dart:io';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_networkimage.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/user/profile.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/profile_list.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var userData;

  File? avatarImageFile;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    // var index = widget.index;
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    print(userJson);
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final user= Provider.of<MyUser>(context);
    var currentFocus;

    unfocus() {
      currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return userData == null
        ? const Loading()
        : StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              // if(snapshot.hasData){
              // UserDetail? userData= snapshot.data ;
              String name = userData['full_name'] ?? 'no name';
              String address = userData['address'] ?? 'no address yet';
              String phone = userData['phone'] ?? 'no phone no added';
              String email = userData['email'] ?? 'Your email';

              List<UserWidget> title = [
                UserWidget(
                    title: name, leading: Icons.person, titleType: 'full_name'),
                UserWidget(
                    title: phone,
                    leading: Icons.mobile_friendly,
                    titleType: 'phone'),
                UserWidget(
                    title: address,
                    leading: Icons.location_on,
                    titleType: 'address'),
                UserWidget(
                    title: email,
                    leading: Icons.email_outlined,
                    titleType: 'email'),
                // UserWidget(title: '******',leading: Icons.password),
              ];
              return Scaffold(
                drawer: const MyDrawer(),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(children: [
                      Builder(
                        builder: (context) => Column(
                          children: [
                            NormalCurveContainer(
                              showDrawer: true,
                              size: size,
                              height: size.height * 0.24,
                              pagetitle: 'Edit Profile',
                              imageUrl: 'assets/svg/arrowback.svg',
                              widget: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Center(
                                  child: Text(
                                    userData['full_name'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: ListView.separated(
                                itemCount: title.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ProfileList(
                                    name: title[index].title,
                                    nameField: title[index].titleType,
                                    leading: title[index].leading,
                                    suffix: Icons.edit,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(50)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: myOrangeGradientTransparent)),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(50)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        BrainWorldColors.myhomepageOrange,
                                        BrainWorldColors.myhomepageLightOrange
                                      ])),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.18),
                          child: Center(
                            child: InkWell(
                              // onTap: () => MyNavigate.navigatejustpush(FullPhotoPage(url: url), context),
                              child: avatarImageFile == null
                                  ? MyNetworkImage(
                                      imgUrl: userData['profilePicture'],
                                    )
                                  : ClipRRect(
                                      //if user pick a file show this
                                      borderRadius: BorderRadius.circular(45),
                                      child: Image.file(
                                        avatarImageFile!,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          child: Padding(
                        padding:
                            EdgeInsets.only(top: size.height * 0.23, left: 61),
                        child: Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              maxRadius: 15,
                              child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 17,
                                    color: BrainWorldColors.myhomepageBlue,
                                  ))),
                        ),
                      )),
                      Positioned(
                          child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.8),
                        child: Center(
                            child: MyButton(
                          placeHolder: 'Back',
                          pressed: () => {Navigator.pop(context)},
                          isGradientButton: true,
                          gradientColors: myblueGradientTransparent,
                        )),
                      ))
                    ]),
                  ),
                ),
              );
            });
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => avatarImageFile = File(path));
    uploadImage(avatarImageFile);
  }

  Future uploadImage(profilePic) async {
    AuthService()
        .updateProfilePicture(profilePic)
        .then((response) => print(response.body));
  }
}
