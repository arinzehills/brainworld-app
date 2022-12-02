import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/my_button.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/orders/widgets/white_card_list.dart';
import 'package:brainworld/services/order_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final _logger = Logger();

    return FutureBuilder(
        future: OrderService.getUserOrders(),
        builder: (context, snapshot) {
          _logger.d('snapshot.data');
          var dataAsMap = snapshot.data as Map;
          return Scaffold(
            appBar: MyAppMenuBar(title: 'Your Orders'),
            drawer: const MyDrawer(),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                children: [
                  Container(
                    // height: 100,
                    // width: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: BrainWorldColors.myhomepageLightBlue
                                .withOpacity(0.6),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              BrainWorldColors.myhomepageBlue,
                              BrainWorldColors.myhomepageLightBlue
                            ])),
                    child: !snapshot.hasData
                        ? buildLoader()
                        : Column(
                            children: [
                              buildText('Total Spent'),
                              buildText(dataAsMap['totalSpent'].toString(),
                                  fontSize: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      buildText('On Courses'),
                                      MyButton(
                                        placeHolder:
                                            dataAsMap['totalSpentOnCourses']
                                                .toString(),
                                        pressed: () {},
                                        isOval: true,
                                        isGradientButton: true,
                                        widthRatio: 0.28,
                                        height: 44,
                                        fontSize: 15,
                                        gradientColors: BrainWorldColors
                                            .myblueGradientTransparent,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      buildText('On Books'),
                                      MyButton(
                                        placeHolder:
                                            dataAsMap['totalSpentOnBooks']
                                                .toString(),
                                        isGradientButton: true,
                                        isOval: true,
                                        widthRatio: 0.28,
                                        height: 44,
                                        fontSize: 15,
                                        pressed: () {},
                                        gradientColors: BrainWorldColors
                                            .myOrangeGradientTransparent,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                  ),
                  !snapshot.hasData
                      ? ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 35),
                          itemBuilder: (context, index) {
                            return buildLoader(isList: true);
                          })
                      : ListView.builder(
                          itemCount: dataAsMap['orders'].length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 35),
                          itemBuilder: (context, index) {
                            OrderInfo order =
                                OrderInfo.fromJson(dataAsMap['orders'][index]);
                            return WhiteCardListWidget(order: order);
                          }),
                ],
              ),
            )),
          );
        });
  }

  buildText(text, {fontSize}) => Padding(
        padding: const EdgeInsets.all(5.0).copyWith(top: 0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      );

  buildLoader({bool isList = false}) {
    return isList
        ? Wrap(children: [
            const Skeleton(width: 70, height: 70),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  width: size(context).width * 0.54,
                ),
                const SizedBox(height: 5),
                Skeleton(
                  width: size(context).width * 0.4,
                ),
                // Skeleton(width: 80, height: 12),
              ],
            ),
          ])
        : Column(
            children: [
              const Skeleton(
                width: 100,
              ),
              const Skeleton(
                width: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Skeleton(
                        width: 100,
                      ),
                      Skeleton(
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: const [
                      Skeleton(
                        width: 100,
                      ),
                      Skeleton(
                        width: 100,
                        height: 50,
                      ),
                    ],
                  )
                ],
              )
            ],
          );
  }
}
