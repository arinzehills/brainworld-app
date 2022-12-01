import 'package:brainworld/components/atm_card_widget.dart';
import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/my_text_field.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/checkout/checkout_summary.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class Checkout extends StatefulWidget {
  const Checkout({
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final CartService cartController = Get.find();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String phone = '';
  String address = '';
  bool autovalidate = false;
  String error = '';

  @override
  void initState() {
    // userData = null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String emailInitialValue = user(context).email;
    String phoneInitialValue = user(context).phone ?? 'Not added';

    return Scaffold(
      drawer: const MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NormalCurveContainer(
                  pagetitle: 'CHECKOUT',
                  size: size,
                  height: size.height * 0.43,
                  containerRadius: 140,
                  widget: AtmCard(size: size, cartController: cartController)),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        hintText: 'Enter your email',
                        initiaiValue: emailInitialValue,
                        autovalidate: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Required'),
                          EmailValidator(errorText: "Enter a Valid Email")
                        ]),
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Phone',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        autovalidate: true,
                        hintText: 'Enter your phone number',
                        isNumberOnly: true,
                        keyboardType: TextInputType.number,
                        initiaiValue: phoneInitialValue,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Required'),
                          MinLengthValidator(11,
                              errorText: 'Enter correct phone number')
                        ]),
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        hintText: 'Enter your address',
                        autovalidate: true,
                        onChanged: (val) {
                          if (mounted) {
                            setState(() => address = val);
                          }
                        },
                        validator:
                            RequiredValidator(errorText: 'Address is required'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: MyButton(
                          isGradientButton: true,
                          gradientColors: myblueGradient,
                          placeHolder: 'Continue',
                          pressed: () {
                            if (_formKey.currentState!.validate()) {
                              MyNavigate.navigatejustpush(
                                  CheckoutSummary(
                                    phone: phone,
                                    address: address,
                                  ),
                                  context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
