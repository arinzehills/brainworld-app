import 'package:brainworld/components/horizontal_listview.dart';
import 'package:brainworld/components/no_items_widget.dart';
import 'package:brainworld/components/utilities_widgets/skeleton.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/pages/chats/models/books_model.dart';
import 'package:brainworld/services/order_service.dart';
import 'package:flutter/material.dart';

class PurchasedBooks extends StatefulWidget {
  const PurchasedBooks({Key? key}) : super(key: key);

  @override
  State<PurchasedBooks> createState() => _PurchasedBooksState();
}

class _PurchasedBooksState extends State<PurchasedBooks> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookModel>>(
        future: OrderService.getUserPurchasedBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //when is loading
            return buildLoading(context);
          }
          if (snapshot.data!.length == 0) {
            return NoItemsWidget();
          }
          var categories = [];
          for (var book in snapshot.data!) {
            categories.add(book.category);
          }
          return Padding(
              padding: EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    libraryList(list: snapshot.data!),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Your Shelfs/Categories',
                          style: TextStyle(fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      height: 250,
                      padding: EdgeInsets.only(bottom: 50),
                      child: ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return libraryList(
                                list: snapshot.data!,
                                category: categories[index]);
                          }),
                    )
                    // libraryList(context),
                  ],
                ),
              ));
        });
  }

  Column libraryList({required List<BookModel> list, category}) {
    List<BookModel> newList = [];
    if (category != null) {
      for (var book in list) {
        if (book.category == category) {
          // setState(() {
          // });
          newList.add(book);
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0).copyWith(left: 16, top: 0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: myblueGradientTransparent)),
                margin: EdgeInsets.only(right: 4),
                height: 14,
                width: 6,
              ),
              Text(
                category != null ? category : 'All books',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Container(
            height: 175.0,
            // width: size(context).width * 1.1,
            child: HorizontalListView(
              list: category != null ? newList : list,
              size: size(context),
            )),
      ],
    );
  }

  Widget buildLoading(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Skeleton(
            width: 70,
          ),
          Row(
            children: [
              Skeleton(
                height: 140,
                width: 140,
              ),
              Skeleton(
                height: 140,
                width: 140,
              ),
              Skeleton(
                height: 140,
                width: 72,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Skeleton(
            width: 70,
          ),
          Row(
            children: [
              Skeleton(
                height: 140,
                width: 140,
              ),
              Skeleton(
                height: 140,
                width: 140,
              ),
              Skeleton(
                height: 140,
                width: 72,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
