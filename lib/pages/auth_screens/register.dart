import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field.dart';
import 'package:brainworld/components/no_account.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/auth_screens/login.dart';
import 'package:brainworld/pages/getstarted_page.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = false;
  String name = '';
  String email = '';

  String password = '';
  bool autovalidate = false;
  String error = '';
  bool loading = false;

  Future<bool> _onBackPressed() {
    return Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => GetStartedPage()),
        )
        .then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(clipBehavior: Clip.hardEdge, children: [
                Positioned(
                  top: -13,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/svg/upcurve.svg',
                    // height: 320,
                  ),
                ),
                Positioned(
                  bottom: -193,
                  // right: 0,
                  child: SvgPicture.asset(
                    'assets/svg/downcurve.svg',
                    // height: 320,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 139.0, left: 11),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: BrainWorldColors.texColor,
                            fontSize: 43,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 10.0, top: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildText(text: 'Full name'),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              hintText: 'Enter your full name',
                              keyboardType: TextInputType.name,
                              autovalidate: false,
                              validator: (val) =>
                                  val!.isEmpty ? 'Please Enter a Name' : null,
                              onChanged: (val) {
                                if (mounted) {
                                  setState(() => name = val);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buildText(text: 'Email'),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextField(
                              hintText: 'Enter your email',
                              autovalidate: autovalidate,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) {
                                if (mounted) {
                                  setState(() => email = val);
                                }
                              },
                              onTap: () {
                                if (autovalidate == true) {
                                  setState(() {
                                    autovalidate = false;
                                  });
                                } else {
                                  setState(() {
                                    autovalidate = true;
                                  });
                                }
                              },
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required'),
                                EmailValidator(errorText: "Enter a Valid Email")
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buildText(text: 'Password'),
                            MyTextField(
                              hintText: 'Enter password',
                              autovalidate: autovalidate,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (val) {
                                if (mounted) {
                                  setState(() => password = val);
                                }
                              },
                              onTap: () {
                                if (autovalidate == true) {
                                  setState(() {
                                    autovalidate = false;
                                  });
                                } else {
                                  setState(() {
                                    autovalidate = true;
                                  });
                                }
                              },
                              obscureText: obscureText,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required'),
                                MinLengthValidator(3,
                                    errorText:
                                        'Password must be at least 6 character long'),
                              ]),
                              suffixIconButton: IconButton(
                                icon: const Icon(Icons.visibility),
                                color: BrainWorldColors.myhomepageBlue,
                                onPressed: () {
                                  if (obscureText == true) {
                                    setState(() {
                                      obscureText = false;
                                    });
                                  } else {
                                    setState(() {
                                      obscureText = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: MyButton(
                                placeHolder: 'SIGN UP',
                                isGradientButton: true,
                                isOval: true,
                                gradientColors: BrainWorldColors
                                    .myOrangeGradientTransparent,
                                widthRatio: 0.45,
                                pressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    var response = await AuthService()
                                        .register(name, email, password);
                                    // var body = json.decode(response.body);
                                    print(response['success']);
                                    if (response['success'] == true) {
                                      snackBar(
                                          const BottomNavigation(),
                                          context,
                                          'Registered in successfully');
                                    } else {
                                      setState(() => loading = false);
                                      setState(
                                          () => error = response['message']);
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            NoAccount(
                              title: 'Already have an account?',
                              subtitle: 'LOGIN',
                              pressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          );
  }

  Text buildText({text}) => Text(
        text,
        style: const TextStyle(
          color: BrainWorldColors.myhomepageBlue,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      );
}
