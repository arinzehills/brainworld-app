import 'package:brainworld/models/user_model.dart';
import 'package:brainworld/services/auth_service.dart';
import 'package:brainworld/services/cart_service.dart';
import 'package:brainworld/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  final CartService controller = Get.put(CartService());
  @override
  Widget build(BuildContext context) {
    return FutureProvider<User?>.value(
      initialData: null,
      catchError: (_, __) => null,
      value: AuthService().getuserFromStorage(),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Wrapper(),
      ),
    );
  }
}
