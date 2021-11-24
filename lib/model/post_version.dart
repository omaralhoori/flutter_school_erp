import 'package:hive/hive.dart';

part '../adapters/post_version.g.dart';

@HiveType(typeId: 8)
class PostVersion extends HiveObject {
  @HiveField(0)
  late String type;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late int version;

  PostVersion({required this.type, required this.name, required this.version});

  PostVersion.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    name = json['name'];
    version = json['version'];
  }
}
