import 'package:brainworld/components/utilities_widgets/mydate_formatter.dart';

class MessageField {
  static const String createdAt = 'createdAt';
}

class UsersMessage {
  final String? id;
  final String sendersid;
  final String? name;
  final String? fileName;
  final String messageText;
  final String type;
  final String? imageURL;
  final String? sentAt;

  const UsersMessage(
      {this.id,
      required this.sendersid,
      this.type = '',
      this.name,
      this.fileName,
      required this.messageText,
      this.imageURL,
      this.sentAt});

  static UsersMessage fromJson(Map<String, dynamic> json) => UsersMessage(
        id: json['_id'],
        sendersid: json['sendersid'],
        name: json['name'],
        fileName: json['fileName'],
        messageText: json['messageText'],
        type: json['messageText'],
        imageURL: json['imageURL'],
        sentAt: MyDateFormatter.dateFormatter(
            datetime: DateTime.parse(json['sentAt']), showHours: true),
        // createdAt:
        // DateTime.fromMillisecondsSinceEpoch(json['createdAt'] * 1000),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sendersid': sendersid,
        'type': type,
        'name': name,
        'fileName': fileName,
        'messageText': messageText,
        'imageURL': imageURL,
        'sentAt': DateTime.now().toString(),
      };
}
