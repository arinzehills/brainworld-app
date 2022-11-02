import 'package:brainworld/models/user.dart';
import 'package:brainworld/services/adminservice/admin_course_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureDropDown extends StatefulWidget {
  String selectedValue;
  // final StringCallback callback;
  void Function(String?)? onChanged;

  FutureDropDown({Key? key, required this.selectedValue, this.onChanged})
      : super(key: key);

  @override
  State<FutureDropDown> createState() => _FutureDropDownState();
}

class _FutureDropDownState extends State<FutureDropDown> {
  // final user = Provider.of<User>(context);
  Widget rangeLists() {
    return FutureBuilder(
        future: AdminCourseService().getAllPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          } else {
            List<DropdownMenuItem<String>> categoriesItems = [
              DropdownMenuItem(
                child: Text(widget.selectedValue),
                value: widget.selectedValue,
              ),
            ];
            var snapshotAsMap = snapshot.data as List;
            for (int i = 0; i < snapshotAsMap.length; i++) {
              if (snapshotAsMap[i]['category'] != widget.selectedValue) {
                categoriesItems.add(
                  DropdownMenuItem(
                    child: Text(snapshotAsMap[i]['category']),
                    value: snapshotAsMap[i]['category'],
                  ),
                );
              }
            }
            return Padding(
              padding: EdgeInsets.all(0.0).copyWith(top: 2, bottom: 2),
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(25)),
                child: DropdownButton<String>(
                  items: categoriesItems,
                  icon: const Icon(
                    Icons.expand_more,
                    color: Colors.grey,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.grey),
                  underline: SizedBox(),
                  onChanged: widget.onChanged,
                  value: widget.selectedValue,
                  hint: Text('My courses'),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return rangeLists();
  }
}
