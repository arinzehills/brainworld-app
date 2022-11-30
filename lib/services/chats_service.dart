class ChatService {
  final String sendersid;

  const ChatService({
    required this.sendersid,
  });
  // static Future openFileifExist(file) async {
  //   if (file == null) {
  //     print('file is null');
  //     return;
  //   }
  //   final url = file.path;
  //   print('+' + url);
  //   await OpenFile.open(url);
  // }

  // Future sendMessage(
  //     {name, message, String? imageURL, groupChatid, type}) async {
  //   // if (sendersid.compareTo(recieversid) > 0) {
  //   //   groupChatId = '$currentUserId-$peerId';
  //   // } else {
  //   //   groupChatId = '$peerId-$currentUserId';
  //   // }
  //   // String groupChatid = sendersid + "-" + recieversid;
  //   final messagesReference =
  //       FirebaseFirestore.instance.collection('chats/$groupChatid/messages');

  //   try {
  //     final newMessage = UsersMessage(
  //       sendersid: sendersid,
  //       name: name,
  //       messageText: message,
  //       type: type,
  //       fileName: type == TypeMessage.file ? name : null,
  //       imageURL: imageURL!,
  //       created_time: DateTime.now().millisecondsSinceEpoch.toString(),
  //     );
  //     await messagesReference.add(newMessage.toJson());
  //     // print(newMessage.toJson());
  //   } catch (e) {
  //     print(e);
  //   }

  // final usersReference
  //          =FirebaseFirestore.instance.collection('users');
  //       await usersReference.doc(userId).update({});
}

class TypeMessage {
  static const text = 'text';
  static const image = 'image';
  static const file = 'file';
}
