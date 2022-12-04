import 'dart:io';

class Course {
  final String? courserid;
  final String usersid;
  final String courseTitle;
  final String price;
  final String? category;
  final String? description; //or post caption
  final String? requirements;
  final String? package;
  final String? videoURL; //description video url
  final File video; //video intro
  final List<File> videos; //other videos
  final List<File> files; //couser files
  List<String> videoUrls; //this is for the course content
  final List<String> filenames;
  final List<String> fileUrls;
  final List<String> subTitles; //they are 14

  Course({
    required this.usersid,
    this.courserid,
    this.category,
    required this.courseTitle,
    required this.price,
    this.description,
    this.requirements,
    this.package,
    this.videos = const [],
    this.files = const [],
    this.videoUrls = const [],
    this.filenames = const [],
    this.fileUrls = const [],
    this.subTitles = const [],
    this.videoURL,
    required this.video,
  });

  static Course fromJson(Map<String, dynamic> json) => Course(
        usersid: json['users_id'],
        courserid: json['_id'],
        courseTitle: json['title'],
        description: json['caption'] ?? json['description'],
        // requirements: json['requirements'],
        category: json['category'],
        price: json['price'],
        package: json['package'],
        videoURL: json['videoURL'],
        // videos: List<File>.from(json['videos']),
        videoUrls: json['videoUrls'],
        // filenames: json['filenames'],
        fileUrls: json['fileUrls'],
        // subTitles: List<String>.from(json['subTitles']),
        video: json['video'],
      );

  Map<String, dynamic> toJson() => {
        'usersid': usersid,
        'courseTitle': courseTitle,
        'category': category,
        'description': description,
        'requirements': requirements,
        'price': price,
        'package': package,
        // 'tags': tags,
        'videoURL': videoURL,
        // 'videonames': videonames,
        'videoUrls': videoUrls,
        'filenames': filenames,
        'fileUrls': fileUrls,
        'subTitles': subTitles,
        'created_time': DateTime.now().toString(),
        'TimeStamp': DateTime.now(),
      };
}
