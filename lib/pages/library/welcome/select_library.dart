import 'package:brainworld/components/my_cachednetwork_image.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class SelectLibrary extends StatefulWidget {
  final String? title;
  final Image? image;
  const SelectLibrary({Key? key, this.image, this.title}) : super(key: key);
  @override
  _SelectLibraryState createState() => _SelectLibraryState();
}

class _SelectLibraryState extends State<SelectLibrary> {
  String sendOrder = 'Send Order';
  String pickup = '';
  @override
  void initState() {
    super.initState();
  }

  Widget _buildList() {
    // final List<String> drivers = <String>['A', 'B', 'C','A', 'B', 'C','A', 'B', 'C'];
    // final user = Provider.of<User>(context);
    List<Map<String, String>> universities = [
      {
        'name': 'UNN',
        'url':
            'https://i.pinimg.com/564x/27/40/be/2740be76c1ad1dcc9b2c1c0b7dbb7d24.jpg'
      },
      {
        'name': 'UNIBEN',
        'url': 'https://www.ngschoolz.net/wp-content/uploads/uniben-logo.png'
      },
      {
        'name': 'F.U.T Minna',
        'url':
            'https://futminna.edu.ng/wp-content/uploads/2020/12/FUTMINNA_LOGO.png'
      },
      {
        'name': 'Unijos',
        'url':
            'https://www.unijos.edu.ng/sites/default/files/inline-images/uo_jos.jpg'
      },
      {
        'name': 'UNIPORT',
        'url':
            'https://estmaster.com/wp-content/uploads/2020/06/uniport-logo-300x290-300x290-1.png'
      },
      {
        'name': "Unilag",
        'url':
            'https://seeklogo.com/images/U/university-of-lagos-logo-38976CB5C4-seeklogo.com.png'
      },
    ];
    return FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(0, 1, 8, 1),
              itemCount: 5, //documents.length,
              itemBuilder: (BuildContext context, int index) {
                //    snapshot.data.docs.map((DocumentSnapshot document) {
                //  dynamic  data= document.data();
                return Card(
                  child: ListTile(
                      title: Text(
                        universities[index]['name']! + ' Library',
                        style: const TextStyle(
                          color: BrainWorldColors.myhomepageBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(-7, 5, 3, 5),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: Constants.avatarRadius,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.avatarRadius)),
                            child: MyCachedNetworkImage(
                              height: 50,
                              width: 50,
                              imgUrl: universities[index]['url']!,
                            )),
                      ),
                      onTap: () => {}),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 1,
              ),
            );
          }
        });
  }

  //used for place order class
  contentBox(context, list) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 50),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Select E-Library you want to access',
                style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrangeAccent,
                    wordSpacing: 3),
              ),
              Text(
                'Varsities e-library',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Divider(),
              Spacer(),
            ],
          ),
        ),
        Container(
            padding:
                const EdgeInsets.only(left: 1, top: 95, right: 1, bottom: 1),
            margin: const EdgeInsets.only(top: Constants.avatarRadius),
            child: list),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/images/brainworld-logo.png")),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, _buildList()),
    );
  }
}
