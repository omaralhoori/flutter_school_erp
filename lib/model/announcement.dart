import 'package:hive/hive.dart';
part '../adapters/announcement.g.dart';

@HiveType(typeId: 0)
class Announcement extends HiveObject {
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

  Announcement({
    required this.title,
    required this.creation,
    required this.name,
    required this.description,
    required this.views,
    required this.likes,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    creation = json['creation'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    views = json['views'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation'] = this.creation;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['views'] = this.views;
    data['likes'] = this.likes;
    return data;
  }
}
