import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final cartTotal;

  AtmCard({
    Key? key,
    required this.size,
    this.cartTotal,
    this.cartController,
  }) : super(key: key);

  final Size size;
  final CartService? cartController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Container(
        height: size.height * 0.29,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: myhomepageLightBlue.withOpacity(0.9),
                // spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [myhomepageBlue, myhomepageLightBlue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ImageIcon(
                     AssetImage('assets/images/visa.png'),
                    size: 60,
                    color: Colors.white,
                  ),
                  Text(
                    'Total: ${cartTotal ?? cartController!.total}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  )
                ],
              ),
            ),
            const Center(
              child:  Text(
                '1234 5678 910 1112',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user(context).full_name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const Text(
                    '11/22',
                    style:  TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
