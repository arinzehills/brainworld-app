import 'dart:convert';

BookModel BookModelFromJson(String str) => BookModel.fromJson(json.decode(str));

String BookModelToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
  BookModel({
    this.id,
    this.usersId,
    this.title,
    this.category,
    this.price,
    this.bookCoverImageURL,
    this.bookURL,
    this.filename,
    this.createdAt,
  });

  String? id;
  String? usersId;
  String? title;
  String? category;
  String? price;
  String? bookCoverImageURL;
  String? bookURL;
  String? filename;
  String? createdAt;

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        id: json["_id"],
        usersId: json["usersId"],
        title: json["title"],
        category: json["category"],
        price: json["price"],
        bookCoverImageURL: json["bookCoverImageURL"],
        bookURL: json["bookURL"],
        filename: json["filename"], //wether file or image
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usersId": usersId,
        "title": title,
        "category": category,
        "bookCoverImageURL": bookCoverImageURL,
        "bookURL": bookURL,
        "filename": filename,
        "createdAt": createdAt,
      };
}
