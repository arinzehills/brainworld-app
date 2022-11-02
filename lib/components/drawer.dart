import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/user.dart';
import 'package:brainworld/pages/auth_screens/login.dart';
import 'package:brainworld/pages/books_library/books_library.dart';
import 'package:brainworld/pages/chats/chat.dart';
import 'package:brainworld/pages/classroom/class_room_welcome.dart';
import 'package:brainworld/pages/homepage.dart';
import 'package:brainworld/pages/laboratory/laboratory.dart';
import 'package:brainworld/pages/library/user_library.dart';
import 'package:brainworld/pages/user/profile.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  // final String uid;
  // final String name;
  // final String email;
  // final String phone;

  MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //  var myred=Color(MyApp().myred);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Container(
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(40).copyWith(left: 10, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(
                      IconlyBold.close_square,
                    ),
                    color: myhomepageBlue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 190,
                    child: Wrap(
                      children: [
                        Text(
                          user.full_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: myhomepageBlue,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildMenuItem(
            context: context,
            index: 0,
            title: 'Home',
          ),
          buildMenuItem(
              context: context,
              isCustomRouting: true,
              index: 7,
              route: UserLibrary(),
              title: 'My Library'),
          buildMenuItem(context: context, index: 1, title: 'Library'),
          buildMenuItem(context: context, index: 2, title: 'Chats'),
          buildMenuItem(context: context, index: 3, title: 'Lab'),
          buildMenuItem(context: context, index: 4, title: 'Books'),
          buildMenuItem(context: context, index: 5, title: 'Profile'),
          buildMenuItem(
              context: context,
              index: 6,
              title: 'Class room',
              isCustomRouting: false,
              route: ClassRoomWelcome()),
          MyButton(
              placeHolder: 'Log out',
              // isOval: true,
              isGradientButton: true,
              gradientColors: myOrangeGradientTransparent,
              pressed: () async {
                await AuthService().logout();
                var response = await AuthService().logout();
                MyNavigate.navigatepushuntil(Login(), context);
                if (response['success'] == true) {
                  snackBar(Login(), context, 'Logged out successfully');
                }
              })
        ]),
      ),
    );
  }

  Widget buildMenuItem({context, index, title, isCustomRouting, route}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.6, bottom: 0.9),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, color: myhomepageBlue),
        ),
        // selected: _selectedIndex == index,
        // selectedColor: myhomepageBlue,
        tileColor: _selectedIndex == index ? myhomepageBlue : null,
        title: Center(
          child: GradientText(
            title ?? 'Library ',
            style: TextStyle(fontSize: 22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _selectedIndex == index
                  ? [Colors.white, Colors.white]
                  : [myhomepageBlue, myhomepageLightBlue],
            ),
          ),
        ),
        onTap: () => {
          setState(() {
            _selectedIndex = index;
          }),
          MyNavigate.navigatepushuntil(
              isCustomRouting != null
                  ? route
                  : BottomNavigation(
                      index: index,
                    ),
              context)
        },
        // selected: _selectedIndex == 5,
      ),
    );
  }
}
