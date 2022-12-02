import 'package:brainworld/components/utilities_widgets/mydate_formatter.dart';

class OrderInfo {
  // final String role;

  final String userId; //owner of course
  final String orderId;
  final String postId;
  final String currentUserId;
  final String currentUsserName;
  final String email;
  final String? phone;
  final String? address;
  final String title;
  final String orderType; //either course or book
  final String? orderOn;
  final String price;

  // final String? profilePhoto;

  OrderInfo({
    required this.userId,
    required this.orderId,
    required this.postId,
    required this.currentUserId,
    required this.currentUsserName,
    required this.email,
    this.address,
    this.phone,
    required this.title, //title of the course
    required this.orderType, //title of the course
    required this.price,
    this.orderOn,
    // this.profilePhoto
  });
  static OrderInfo fromJson(Map<String, dynamic> json) => OrderInfo(
        orderId: json['order_id'],
        userId: json['user_id'],
        currentUserId: json['current_user_id'],
        postId: json['post_id'],
        currentUsserName: json['current_user_name'],
        email: json['email'],
        address: json['address'],
        // profilePhoto: json['profilePhotoUrl'],
        phone: json['phone'],
        title: json['title'],
        price: json['price'],
        orderType: json['orderType'],
        orderOn: MyDateFormatter.dateFormatter(
          datetime:
              DateTime.parse(json['orderedOn'] ?? '2022-11-02 19:10:31.998691'),
        ),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'order_id': orderId,
        'current_user_id': currentUserId,
        'post_id': postId,
        'orderType': orderType,
        'current_user_name': currentUsserName,
        'email': email,
        'phone': phone,
        'address': address,
        'title': title,
        'price': price,
        "orderOn": DateTime.now().toString()
      };
}
