import 'dart:convert';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_networkimage.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/auth_screens/login.dart';
import 'package:brainworld/pages/user/components/profile_list.dart';
import 'package:brainworld/pages/user/edit_profile.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class UserWidget {
  String title;
  String? titleType;
  IconData? leading;
  UserWidget({required this.title, this.titleType, this.leading});
}

class _ProfileState extends State<Profile> {
  var userData;
  var userRegData;
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');

    var user = json.decode(userJson!);
    print(user['_id']);
    print(user);
    // User user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    // var index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context);

    return userData == null
        ? const Loading()
        : Builder(builder: (context) {
            List<UserWidget> title = [
              UserWidget(
                  title: userData['full_name'] ?? 'Your name',
                  leading: Icons.person),
              UserWidget(
                  title: userData['phone'] ?? 'no phone no added',
                  leading: Icons.mobile_friendly),
              UserWidget(
                  title: userData['email'] ?? 'Your email',
                  leading: Icons.email_outlined),
              UserWidget(
                  title: userData['address'] ?? 'no address',
                  leading: Icons.location_on),
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
                            size: size,
                            height: size.height * 0.24,
                            pagetitle: 'Profile',
                            showDrawer: true,
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
                              itemCount: 4,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                //  DocumentSnapshot  document=snapshot.data as DocumentSnapshot<Object?>;
                                //    dynamic orderData=document.data();
                                return ProfileList(
                                  name: title[index].title,
                                  leading: title[index].leading,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(50)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          BrainWorldColors.myhomepageLightBlue,
                                          BrainWorldColors.myhomepageBlue
                                        ])),
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
                                      BrainWorldColors.myhomepageLightBlue,
                                      BrainWorldColors.myhomepageBlue
                                    ])),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyButton(
                            placeHolder: 'Logout',
                            isOval: true,
                            withBorder: true,
                            widthRatio: 0.4,
                            height: 50,
                            isGradientButton: true,
                            gradientColors: myOrangeGradientTransparent,
                            pressed: () async {
                              var response = await AuthService().logout();
                              MyNavigate.navigatepushuntil(
                                  const Login(), context);
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.17),
                      child: Center(
                          child: MyNetworkImage(
                        imgUrl: user.profilePicture!,
                        height: 85,
                        width: 85,
                      )),
                    )),

                    // Positioned(
                    //     child: Padding(
                    //   padding: EdgeInsets.only(top: size.height * 0.16),
                    //   child: Center(
                    //     child: profilePhoto != null
                    //         ? CupertinoButton(
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => FullPhotoPage(
                    //                     url: profilePhoto,
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //             child: ClipRRect(
                    //               borderRadius: BorderRadius.circular(45),
                    //               child: Image.network(
                    //                 profilePhoto,
                    //                 width: 90,
                    //                 height: 90,
                    //                 fit: BoxFit.cover,
                    //                 errorBuilder:
                    //                     (context, object, stackTrace) {
                    //                   return ClipRRect(
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(50)),
                    //                       child: Image.asset(
                    //                         "assets/user_blue.png",
                    //                         height: 50,
                    //                       ));
                    //                 },
                    //                 loadingBuilder: (BuildContext context,
                    //                     Widget child,
                    //                     ImageChunkEvent? loadingProgress) {
                    //                   if (loadingProgress == null) return child;
                    //                   return Container(
                    //                     width: 90,
                    //                     height: 90,
                    //                     child: Center(
                    //                       child: CircularProgressIndicator(
                    //                         color: myhomepageBlue,
                    //                         value: loadingProgress
                    //                                     .expectedTotalBytes !=
                    //                                 null
                    //                             ? loadingProgress
                    //                                     .cumulativeBytesLoaded /
                    //                                 loadingProgress
                    //                                     .expectedTotalBytes!
                    //                             : null,
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           )
                    //         : ClipRRect(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(50)),
                    //             child: Image.asset(
                    //               "assets/user_blue.png",
                    //               height: 90,
                    //             )),
                    //   ),
                    // )),
                    Positioned(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.74, bottom: size.height * 0.19),
                      child: Center(
                          child: MyButton(
                        placeHolder: 'Edit profile',
                        // isOval: true,
                        withBorder: true,
                        height: 50,
                        gradientColors: myblueGradientTransparent,
                        isGradientButton: true,
                        pressed: () {
                          MyNavigate.navigatejustpush(
                              const EditProfile(), context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: ImageIcon(
                            AssetImage('assets/images/edit_user.png'),
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                    ))
                  ]),
                ),
              ),
            );
          });
  }
}
