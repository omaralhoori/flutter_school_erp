import 'package:hive/hive.dart';
part '../adapters/announcement.g.dart';

@HiveType(typeId: 0)
class Announcement extends HiveObject {
  @HiveField(0)
  late String creation;
  @HiveField(1)
  late String? image;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late String? description;
  @HiveField(4)
  late String name;

  Announcement({
    required this.title,
    required this.creation,
    required this.name,
    this.description,
    this.image,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    creation = json['creation'];
    image = json['image'];
    title = json['title'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation'] = this.creation;
    data['image'] = this.image;
    data['title'] = this.title;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
