import 'package:hive/hive.dart';

part '../adapters/content.g.dart';


@HiveType(typeId: 3)
class Content extends HiveObject {
  @HiveField(0)
  late String contentType;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late String description;
  @HiveField(4)
  late String creation;
  @HiveField(5)
  late int likes;
  @HiveField(6)
  late int views;
  @HiveField(7)
  late int approvedComments;
  @HiveField(8)
  late String fileUrl;
  @HiveField(9)
  late int isViewed;
  @HiveField(10)
  late int isLiked;


  Content({
    required this.contentType,
    required this.name,
    required this.title,
    required this.description,
    required this.creation,
    required this.likes,
    required this.views,
    required this.approvedComments,
    required this.fileUrl,
    required this.isViewed,
    required this.isLiked,
  });

  Content.fromJson(Map<String, dynamic> json) {
    contentType = json['type'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    creation = json['creation'];
    likes = json['likes'];
    views = json['views'];
    approvedComments = json['approved_comments'];
    fileUrl = json['file_url'];
    isViewed = json['is_viewed'];
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.contentType;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['creation'] = this.creation;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['approved_comments'] = this.approvedComments;
    data['file_url'] = this.fileUrl;
    data['is_viewed'] = this.isViewed;
    data['is_liked'] = this.isLiked;
    return data;
  }
}
