import 'package:brainworld/pages/chats/models/message.dart';
import 'package:flutter/material.dart';

// class ChatController extends GetxController {
//   var chatMessages = <UsersMessage>[].obs;
//   var chatUsers = <User>[].obs;
// }

class ChatController extends ChangeNotifier {
  final List<UsersMessage> _messages = [];

  List<UsersMessage> get messages => _messages;

  addNewMessage(UsersMessage message) {
    _messages.add(message);
    notifyListeners();
  }
}
