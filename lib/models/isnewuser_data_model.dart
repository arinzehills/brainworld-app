import 'dart:convert';

IsNewUserModel newUserModelFromJson(String str) =>
    IsNewUserModel.fromJson(json.decode(str));

String newUserModelToJson(IsNewUserModel data) => json.encode(data.toJson());

class IsNewUserModel {
  IsNewUserModel(
      {required this.id,
      required this.username,
      required this.newlyRegistered,
      required this.bookLib,
      required this.lab,
      required this.library,
      required this.classRoom,
      required this.chat,
      this.message,
      required this.regAt});

  String? id;
  String? username;
  bool? newlyRegistered;
  bool? bookLib;
  bool library;
  bool? lab;
  bool? classRoom;
  bool? chat;
  String? regAt;
  String? message;

  factory IsNewUserModel.fromJson(Map<String, dynamic> json) => IsNewUserModel(
        id: json["id"],
        username: json["username"],
        newlyRegistered: json["newlyRegistered"],
        bookLib: json["bookLib"],
        library: json["library"],
        lab: json["lab"],
        classRoom: json["classRoom"],
        chat: json["chat"],
        regAt: json["regAt"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "newlyRegistered": newlyRegistered,
        "bookLib": bookLib,
        "library": library,
        "lab": lab,
        "chat": chat,
        "classRoom": classRoom,
        "regAt": regAt,
        "message": message,
      };
}
