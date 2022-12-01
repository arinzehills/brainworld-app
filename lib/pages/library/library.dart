import 'package:brainworld/components/custom_tab.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/components/nothing_yet_widget.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/constants/api_utils_constants.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/chats/models/isnewuser_data_model.dart';
import 'package:brainworld/pages/library/user_library.dart';
import 'package:brainworld/pages/library/welcome/library_welcome.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  late IsNewUserModel userInfoData;
  bool showIntroPage = true;

  bool loading = true; //i.e show d intro page
  @override
  void initState() {
    super.initState();
    _getUserRegInfo();
  }

  _getUserRegInfo() async {
    var userInfo = await getUserRegInfo();

    setState(() {
      userInfoData = IsNewUserModel.fromJson(userInfo);
    });
    setState(() => {loading = false});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return loading
        ? const Loading()
        : (showIntroPage && userInfoData.library == true)
            ? NothingYetWidget(
                pageTitle: 'WELCOME TO BRAINWORLD MERGED E-LIBRARY',
                pageHeader: "UNIVERSITY E-LIBRARY",
                imageURL: 'manwithpc.png',
                pageContentText:
                    'Welcome to Brain world merged library you can have access \n'
                    'to any university e-resources with ease here,with just a small access fee,and also have your own personal library\n',
                onClick: () async {
                  var userModel = IsNewUserModel(
                      id: user.id,
                      username: user.fullName,
                      newlyRegistered: true,
                      bookLib: userInfoData.classRoom == false ? false : true,
                      library: false,
                      lab: userInfoData.lab == false ? false : true,
                      classRoom: true,
                      chat: userInfoData.chat == false ? false : true,
                      regAt: 'regAt');
                  AuthService.setIsNewUser(userModel);
                  setState(() => {showIntroPage = false});
                  // MyNavigate.navigatejustpush(AddToBooks(), context);
                },
              )
            : Scaffold(
                drawer: const MyDrawer(),
                appBar: MyAppMenuBar(title: 'Library'),
                body: CustomTab(
                  widgetsItems: const [LibraryWelcome(), UserLibrary()],
                  items: const ['Library', 'My Library'],
                ),
              );
  }
}
