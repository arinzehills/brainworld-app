import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/myappbar.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/purchased/purchased_books.dart';
import 'package:brainworld/pages/purchased/purchased_courses.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Purchased extends StatefulWidget {
  const Purchased({Key? key}) : super(key: key);

  @override
  State<Purchased> createState() => _PurchasedState();
}

class _PurchasedState extends State<Purchased> {
  List<String> items = ["Course", "Books"];
  List<Widget> purchasedItems = [
    const PurchasedCourses(),
    const PurchasedBooks()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppMenuBar(title: 'Purchased Items'),
      body: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() => {currentIndex = index});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: currentIndex == index
                                        ? myblueGradient
                                        : const [
                                            Color.fromARGB(35, 34, 86, 255),
                                            Color.fromARGB(65, 20, 118, 255)
                                          ],
                                    begin: Alignment.topCenter)),
                            margin: const EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                    color: currentIndex == index
                                        ? Colors.white
                                        : BrainWorldColors.myhomepageBlue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            //Main Body
            Container(
                width: double.infinity,
                height: size(context).height * 0.67,
                margin: const EdgeInsets.only(top: 10),
                child: purchasedItems[currentIndex]),
          ],
        ),
      ),
    );
  }
}
