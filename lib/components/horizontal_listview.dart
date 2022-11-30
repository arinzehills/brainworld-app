import 'dart:io';

import 'package:brainworld/components/my_cachednetwork_image.dart';
import 'package:brainworld/components/utilities_widgets/gradient_text.dart';
import 'package:brainworld/components/utilities_widgets/my_navigate.dart';
import 'package:brainworld/components/utilities_widgets/url_to_readable.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/books_model.dart';
import 'package:brainworld/pages/chats/models/cart_model.dart';
import 'package:brainworld/pages/fullresourcepage/full_pdf_page.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:brainworld/utils/pdf_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:path_provider/path_provider.dart';

class HorizontalListView extends StatefulWidget {
  const HorizontalListView(
      {Key? key,
      required this.size,
      this.pageType,
      required this.list,
      this.categoryStr})
      : super(key: key);
  // final Stream<QuerySnapshot>? stream;
  final Size size;
  final String? categoryStr;
  final String? pageType;
  final List<BookModel> list;

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  final cartController = Get.put(CartService());

  // bool loading = false;
  Map<int, bool> loading = {};

  @override
  Widget build(BuildContext context) {
    // print('widget.categoryStr ' + widget.categoryStr.toString());

    return SizedBox(
      child: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: myhomepageBlue),
              );
            } else {
              return
                  // ? Center(
                  //     child: Text('No Courses for this category yet!'),
                  //   )
                  // :
                  Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.list.length,
                    itemBuilder: (context, index) {
                      print(loading[1]);
                      String filename = widget.list[index].filename!;
                      BookModel book = widget.list[index];
                      CartModel cartModel = CartModel(
                          user_id: book.usersId!,
                          post_id: book.id,
                          title: book.title,
                          price: book.price,
                          imageUrl: book.bookCoverImageURL,
                          postType: 'book');

                      return Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 5, right: 5, bottom: 5),
                          child: GestureDetector(
                            onDoubleTap: () {}, //when double tap add to cart
                            onTap: () {
                              widget.pageType == 'books'
                                  ? seeDetailsModalBottomSheet(
                                      context: context,
                                      // course: course,
                                      cartController: cartController)
                                  : openPDF(context, widget.list[index].bookURL,
                                      widget.list[index].filename, index);
                            },
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 120,
                              ),
                              height: 100,
                              width: widget.size.width * 0.35,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 30,
                                        spreadRadius: 0,
                                        offset: const Offset(5, 20))
                                  ]),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    loading[index] == true
                                        ? SizedBox(
                                            height: 90,
                                            width: 90,
                                            child: CircularProgressIndicator(
                                              color: myhomepageBlue,
                                            ),
                                          )
                                        : MyCachedNetworkImage(
                                            imgUrl: widget.list[index]
                                                    .bookCoverImageURL ??
                                                UrlToReadable.urlToReadableURL(
                                                    widget.list[index].bookURL!,
                                                    '.png'),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0)
                                          .copyWith(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 95,
                                            child: Text(
                                              widget.list[index].title,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // Icon(
                                          //     IconlyBold.delete,
                                          //     color: Colors.red,
                                          //     size: 12,
                                          //   ),
                                          widget.pageType == 'books'
                                              ? GestureDetector(
                                                  onTap: () {
                                                    cartController
                                                        .addCourse(cartModel);
                                                  },
                                                  child: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: myhomepageBlue,
                                                    size: 22,
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets.all(1.6),
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                               Radius.circular(
                                                                  50)),
                                                      color: Colors.red),
                                                  child: const Icon(
                                                    IconlyBold.delete,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                    if (widget.pageType == 'books')
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GradientText(
                                            'Price: N${widget.list[index].price}',
                                            gradient: LinearGradient(
                                                colors: myblueGradient),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }),
              );
            }
          }),
    );
  }

  openPDF(BuildContext context, String? bookURL, filename, index) async {
    setState(() {
      loading[index] = true;
    });
    Directory dirrec = await getApplicationDocumentsDirectory();
    // var fileinstorage = File('${dirrec.path}/$filename'),
    //     iffileExists = await File(fileinstorage.path).exists();
    // if (iffileExists) {
    //   MyNavigate.navigatejustpush(
    //       FullPDFPage(file: fileinstorage, filename: filename), context);
    // } else {
    final file = await PdfUtil.loadNetwork(bookURL!);
    setState(() {
      loading[index] = false;
    });

    MyNavigate.navigatejustpush(
        FullPDFPage(file: file, filename: filename), context);
    // }
  }
}
