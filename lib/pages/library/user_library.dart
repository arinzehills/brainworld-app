import 'package:brainworld/components/drawer.dart';
import 'package:brainworld/components/horizontal_listview.dart';
import 'package:brainworld/components/nothing_yet_widget.dart';
import 'package:brainworld/components/utilities_widgets/loading.dart';
import 'package:brainworld/constants/constant.dart';
import 'package:brainworld/models/models.dart';
import 'package:brainworld/pages/upload/add_to_local_library.dart';
import 'package:brainworld/services/upload_service.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class UserLibrary extends StatefulWidget {
  const UserLibrary({Key? key}) : super(key: key);

  @override
  State<UserLibrary> createState() => _UserLibraryState();
}

class _UserLibraryState extends State<UserLibrary> {
  final _logger = Logger();

  bool loading = false;
  late Future booksData;
  int categoryLength = 0;
  int bookLength = 0;
  @override
  void initState() {
    super.initState();
    refreshUsersBooks();

    // var index = widget.index;
  }

  Future refreshUsersBooks() async {
    setState(() => loading = true);

    //this.students = await TransactionService.
    //              transactionInstance.getUserTransactions(1);
    booksData = UploadService().getUserBooks();
    _logger.d('books_data');
    // var books_data2 = books_data as Map;
    booksData.then((value) => {
          _logger.d('value'),
          _logger.d(value['categories']),
          setState(() => categoryLength = value['categories'].length),
          setState(() => bookLength = value['books'].length)
        });
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        body: bookLength == 0
            ? const Center(
                child: NothingYetWidget(
                  pageTitle: 'UPLOAD TO BOOKS LIBRARY',
                  pageHeader: "My Books Library",
                  isFullPage: false,
                  pageContentText:
                      'You can save your books here for future purposes,\n'
                      'reference and books related to the courses you want\n to take or currently taking. No books added yet',
                ),
              )
            : Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 15),
                      // color: Color.fromARGB(255, 13, 39, 127),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: myOrangeGradientTransparent)),
                      height: size(context).height * 0.18,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // IconButton(
                          //   onPressed: () =>
                          //       _scaffoldKey.currentState?.openDrawer(),
                          //   icon: SvgPicture.asset('assets/svg/menuicon.svg',
                          //       height: 25,
                          //       width: 25,
                          //       color: Colors.white,
                          //       semanticsLabel: 'A red up arrow'),
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                       Radius.circular(50)),
                                  child: Image.asset(
                                    "assets/images/glory.png",
                                    height: 80,
                                  )),
                              buildUserDescription(user)
                            ],
                          ),
                        ],
                      )),
                  Align(
                      // top: 1,
                      alignment: const Alignment(0, -0.57),
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: textField())),
                  Padding(
                      // alignment: Alignment(0, size(context).height * 0.00069),
                      padding:
                          EdgeInsets.only(top: size(context).height * 0.25),
                      child: FutureBuilder(
                          future: booksData,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              _logger.d('sdhasdfbgu ' + snapshot.error.toString());
                              return Text(snapshot.error.toString());
                            } else if (snapshot.data == null) {
                              return const Loading();
                            } else {
                              var bookItemsMap = snapshot.data! as Map;
                              List<BookModel> books = [];
                              for (var data in bookItemsMap['books']) {
                                books.add(BookModel.fromJson(data));
                              }
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    libraryList(list: books),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text('Your Shelfs/Categories',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    Container(
                                      height: 250,
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount:
                                              bookItemsMap['categories']
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return libraryList(
                                                list: books,
                                                category:
                                                    bookItemsMap['categories']
                                                        [index]);
                                          }),
                                    )
                                    // libraryList(context),
                                  ],
                                ),
                              );
                            }
                          })),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddToLocalLibray()));
          },
          backgroundColor: Colors.transparent,
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(15),
            child: const Icon(IconlyBold.paper_plus),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: myblueGradientTransparent)),
          ),
        ));
  }

  buildUserDescription(user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Text(
            user.fullName,
            style: const TextStyle(
                color: BrainWorldColors.myhomepageBlue,
                fontSize: 23,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 3,
          ),
          const Text(
            'Software developer and designer',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/booksicon.svg',
                      height: 12,
                      fit: BoxFit.fill,
                      color: Colors.white,
                      semanticsLabel: 'A red up arrow'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$bookLength books in your library',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              Row(
                children: [
                  const Icon(
                    IconlyBold.scan,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$categoryLength shelfs',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
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
                margin: const EdgeInsets.only(right: 4),
                height: 14,
                width: 6,
              ),
              Text(
                category != null ? category : 'All books',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(
            height: 175.0,
            // width: size(context).width * 1.1,
            child: HorizontalListView(
              list: category != null ? newList : list,
              size: size(context),
            )),
      ],
    );
  }

  Container textField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 50.0,
              spreadRadius: 2.0,
            ),
          ]),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Search here...',
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: BrainWorldColors.myhomepageBlue, width: 0.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(
              IconlyBold.search,
              color: BrainWorldColors.iconsColors,
            )),
      ),
    );
  }
}
