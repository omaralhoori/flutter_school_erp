import 'package:hive/hive.dart';

part '../adapters/album.g.dart';

@HiveType(typeId: 1)
class Album {
  @HiveField(0)
  late String creation;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late String description;
  @HiveField(4)
  late int views;
  @HiveField(5)
  late int likes;
  @HiveField(6)
  late int approvedComments;
  @HiveField(7)
  late String fileUrl;
  @HiveField(8)
  late int isViewed;
  @HiveField(9)
  late int isLiked;
  @HiveField(10)
  String? section;
  @HiveField(11)
  String? classCode;
  @HiveField(12)
  String? branch;

  Album({
    required this.title,
    required this.creation,
    required this.name,
    required this.description,
    required this.views,
    required this.likes,
    required this.approvedComments,
    required this.fileUrl,
    required this.isViewed,
    required this.isLiked,
    required this.section,
    required this.classCode,
    required this.branch,
  });

  Album.fromJson(Map<String, dynamic> json) {
    creation = json['creation'];
    name = json['name'];
    title = json['title'];
    description = json['description'] ?? '';
    views = json['views'];
    likes = json['likes'];
    approvedComments = json['approved_comments'];
    fileUrl = json['file_url'];
    isViewed = json['is_viewed'];
    isLiked = json['is_liked'];
    section = json['section'];
    classCode = json['class_code'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation'] = this.creation;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['views'] = this.views;
    data['likes'] = this.likes;
    data['approved_comments'] = this.approvedComments;
    data['file_url'] = this.fileUrl;
    data['is_viewed'] = this.isViewed;
    data['is_liked'] = this.isLiked;
    data['section'] = this.section;
    data['class_code'] = this.classCode;
    data['branch'] = this.branch;
    return data;
  }
}
