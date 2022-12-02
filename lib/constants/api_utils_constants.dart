import 'dart:convert';
import 'dart:math';
import 'package:brainworld/models/models.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

Future<User> getuserFromStorage() async {
  //provider will use this one
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  var userString = localStorage.getString('user');
  // print(userJson);
  var userJson = json.decode(userString!);
  // print(user['_id']);
  // User user = json.decode(userJson!);
  User user = User.fromJson(userJson);
  return user;
}

Future getUserRegInfo() async {
  final _logger = Logger();
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  var userString = localStorage.getString('isNewUserData');
  var userJson = json.decode(userString!);
  _logger.d(userJson);
  _logger.d('userJson');
  // var user = json.decode(userJson!);
  // print('user['_id']');
  IsNewUserModel user = IsNewUserModel.fromJson(userJson);

  return userJson;
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
