import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/radial_gradient.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  final String? name;
  final String? nameField;
  final IconData? leading;
  final IconData? suffix;
  final String? imageUrl;
  const ProfileList(
      {Key? key,
      @required this.name,
      this.nameField,
      @required this.leading,
      this.suffix,
      this.imageUrl})
      : super(key: key);
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  bool textFieldState = false;
  String textValuetoUpdate = '';
  final _formKey = GlobalKey<FormState>();

  var error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context){
        //     return ChatDetail();
        //   }));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(widget.imageUrl!) ,
                  //   maxRadius: 30,
                  // ),
                  RadiantGradientMask(
                      child: Icon(
                    widget.leading,
                    size: 30,
                    color: Colors.white,
                  )),

                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Container(
                        color: Colors.transparent,
                        child: Text(
                          widget.name!,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        )),
                  ),
                  RadiantGradientMask(
                      child: IconButton(
                    icon: Icon(
                      widget.suffix,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      buildEditPopup();
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future buildEditPopup() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              height: 277,
              // constraints: BoxConstraints(ma),
              // padding: EdgeInsets.all(20),
              child: Center(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      'Edit Profile',
                      gradient:
                          LinearGradient(colors: myOrangeGradientTransparent),
                      style: const TextStyle(
                          color: BrainWorldColors.myhomepageBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                    loading
                        ? const CircularProgressIndicator(
                            color: BrainWorldColors.myhomepageBlue,
                          )
                        : Image.asset(
                            'assets/images/girlwithpc.png',
                            height: 65,
                            width: 90,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                      child: MyTextField(
                        hintText: widget.name!,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a value' : null,
                        onChanged: (val) {
                          setState(() => textValuetoUpdate = val);
                        },
                      ),
                    ),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                    MyButton(
                      placeHolder: 'Update',
                      pressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var user = await AuthService().getuserFromStorage();
                          var dataToUpdate = {
                            widget.nameField!: textValuetoUpdate,
                            'token': user.token!,
                          };
                          var response = await AuthService()
                              .updateUser(dataToupdate: dataToUpdate);

                          if (response['success'] == true) {
                            setState(() => {});
                            Navigator.pop(context);
                            snackBar(
                                const BottomNavigation(
                                  index: 5,
                                ),
                                context,
                                'Updated successfully');
                          } else {
                            setState(() => loading = false);
                            setState(() => error = response['message']);
                          }
                        }
                      },
                      isGradientButton: true,
                      gradientColors: myblueGradientTransparent,
                    )
                  ],
                ),
              )),
            ),
          );
        });
  }
}
