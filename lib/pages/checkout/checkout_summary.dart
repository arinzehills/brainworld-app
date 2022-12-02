import 'package:brainworld/components/atm_card_widget.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/cart_model.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:get/get.dart';
import '../../components/bottomnavigation.dart';
import '../../services/cart_service.dart';

class CheckoutSummary extends StatefulWidget {
  const CheckoutSummary({Key? key, required this.phone, required this.address})
      : super(key: key);
  final String phone;
  final String address;
  @override
  _CheckoutSummaryState createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummary> {
  final CartService cartController = Get.find();
  bool orderStatus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Column(
            children: [
              NormalCurveContainer(
                pagetitle: 'CHECKOUT SUMMARY',
                size: size,
                height: size.height * 0.49,
                containerRadius: 140,
                widget: AtmCard(size: size, cartController: cartController),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              BrainWorldColors.myhomepageBlue.withOpacity(0.6),
                          // spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        orderStatus == true
                            ? orderSuccessWidget()
                            : ListView.builder(
                                // itemCount: info.toJson().length,
                                itemCount: cartController.cartItems.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // print('oga ${info.toJson().length}');
                                  final courses =
                                      cartController.cartItems.keys.toList();
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              courses[index].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'NGN : ${courses[index].price}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                        if (orderStatus == false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: Center(
                              child: MyButton(
                                isGradientButton: true,
                                gradientColors: myOrangeGradientTransparent,
                                widthRatio: 0.6,
                                isOval: true,
                                placeHolder: 'Pay ',
                                // pressed: () {
                                //   setState(() {
                                //     orderStatus = !orderStatus;
                                //   });
                                // },
                                pressed: _onPressed,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget orderSuccessWidget() {
    // return Text('Hey');
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                const GradientText('Transaction successful',
                    style: TextStyle(fontSize: 17),
                    gradient: LinearGradient(colors: [
                      BrainWorldColors.myhomepageBlue,
                      BrainWorldColors.myhomepageLightBlue
                    ])),
                Image.asset(
                  'assets/images/dullbaby.png',
                  height: 190,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  placeHolder: 'Go to home',
                  isOval: true,
                  isGradientButton: true,
                  widthRatio: 0.37,
                  fontSize: 16,
                  gradientColors: myOrangeGradientTransparent,
                  pressed: () {
                    MyNavigate.navigatepushuntil(const BottomNavigation(), context);
                  },
                ),
                MyButton(
                  placeHolder: 'Check orders',
                  gradientColors: myblueGradient,
                  isGradientButton: true,
                  isOval: true,
                  widthRatio: 0.4,
                  fontSize: 16,
                  pressed: () {
                    // MyNavigate.navigateandreplace(MyCourses(), context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _onPressed() {
    // this._handlePaymentInitialization();
    // print(object)
    final cartItem = cartController.cartItems.keys.toList();
    CartService.purchaseCourse(cartItem, context);
  }

  _handlePaymentInitialization() async {
    final flutterwave = Flutterwave.forUIPayment(
      amount: cartController.total,
      currency: FlutterwaveCurrency.NGN,
      context: this.context,
      publicKey: "FLWPUBK_TEST-b6fec30caf684ee6845762074efb8ce3-X",
      encryptionKey: 'FLWSECK_TESTa753a5576d98',
      email: user(context).email,
      fullName: user(context).fullName,
      txRef: DateTime.now().toIso8601String(),
      narration: "Brain World academy",
      isDebugMode: true,
      phoneNumber: widget.phone,
      acceptCardPayment: true,
    );
    final response = await flutterwave.initializeForUiPayments();
    if (response != null) {
      print(response.data!.status);
      // setState(() {
      //   loading = true;
      // });
      if (response.data!.status == 'successful') {
        final List<CartModel> cartItem = cartController.cartItems.keys.toList();
        CartService.purchaseCourse(cartItem, context);
        setState(() {
          orderStatus = true;
        });
      }
    } else {
      Get.snackbar("No Response!", 'You cancelled the purchase');
    }
  }
}
