import 'package:brainworld/components/bottomnavigation.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/pages/cart/cart_page.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyAppMenuBar extends StatelessWidget with PreferredSizeWidget {
  MyAppMenuBar({
    Key? key,
    required this.title,
    this.imageUrl,
    this.showRightIcons = true,
  }) : super(key: key);

  final String title;
  final bool showRightIcons;
  final String? imageUrl;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    bool? showDrawer;
    final CartService cartController = Get.find();

    return AppBar(
      centerTitle: title != 'Home' ? false : true,
      title: title != 'Home'
          ? Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          : Image.asset(
              'assets/images/brainworld-logo.png',
              height: 75,
              width: 75,
            ),
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      leading: Container(
        padding: const EdgeInsets.only(left: 13),
        height: 10,
        width: 10,
        child: showDrawer == null
            ? IconButton(
                onPressed: () => {
                  if (imageUrl == null)
                    {Scaffold.of(context).openDrawer()}
                  else
                    {Navigator.pop(context)}
                },
                icon: SvgPicture.asset(
                    imageUrl == null ? 'assets/svg/menuicon.svg' : imageUrl!,
                    // height: 100,
                    // fit: BoxFit.fill,
                    color: Colors.black,
                    semanticsLabel: 'A red up arrow'),
              )
            : const SizedBox(),
      ),
      actions: !showRightIcons
          ? []
          : [
              Obx(
                () => Container(
                  padding: const EdgeInsets.only(right: 20),
                  height: 33,
                  // width: 33,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => {showCartBottomSheet(context)},
                              child: SvgPicture.asset('assets/svg/carticon.svg',
                                  height: 25,
                                  width: 25,
                                  // fit: BoxFit.fill,
                                  color: BrainWorldColors.iconsColors,
                                  semanticsLabel: 'A red up arrow'),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () => MyNavigate.navigatepushuntil(
                                  const BottomNavigation(
                                    index: 5,
                                  ),
                                  context),
                              child: SvgPicture.asset(
                                  'assets/svg/profileicon.svg',
                                  height: 22,
                                  width: 22,
                                  color: BrainWorldColors.iconsColors,
                                  semanticsLabel: 'A red up arrow'),
                            ),
                          ],
                        ),
                        Positioned(
                            // alignment: Alignment.bottomCenter,
                            right: 29,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => {showCartBottomSheet(context)},
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: LinearGradient(
                                        colors: BrainWorldColors
                                            .myOrangeGradientTransparent)),
                                child: Center(
                                    child: Text(
                                  '${cartController.cartItems.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
