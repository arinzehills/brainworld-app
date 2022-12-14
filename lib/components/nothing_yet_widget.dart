import 'package:brainworld/components/normal_curve_container.dart';
import 'package:brainworld/themes/themes.dart';
import 'package:flutter/material.dart';

class NothingYetWidget extends StatelessWidget {
  const NothingYetWidget(
      {Key? key,
      required this.pageTitle,
      required this.pageHeader,
      this.imageURL,
      this.isFullPage = true,
      // this.onClick,
      this.pageContentText,
      this.widget})
      : super(key: key);
  final Widget? widget;
  final String pageTitle;
  final String? imageURL;
  final String pageHeader;
  final bool isFullPage;
  final String? pageContentText;
  // final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        isFullPage
            ? NormalCurveContainer(
                size: size,
                height: size.height * 0.21,
                showDrawer: false,
                containerRadius: 90,
                widget: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                    child: Column(
                      children: [
                        const ImageIcon(
                          AssetImage('assets/images/uploads_blue.png'),
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          pageTitle,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: isFullPage ? 0 : size.height * 0.09,
              ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/${imageURL ?? 'librarybooks.png'}',
                height: 240,
              ),
              Text(
                pageHeader,
                style: TextStyle(
                    color: BrainWorldColors.myhomepageBlue.withOpacity(0.7),
                    fontSize: 32,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                pageContentText ?? '',
                textAlign: TextAlign.center,
              ),
              // ExpandableTextWidget(
              //     text: (pageContentText! + pageContentText!) ?? ''),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: widget,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
