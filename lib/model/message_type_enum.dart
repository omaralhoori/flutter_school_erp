import 'package:hive/hive.dart';
part '../adapters/message_type_enum.g.dart';

@HiveType(typeId: 9)
enum MessageType {
  @HiveField(0)
  direct,
  @HiveField(1)
  group
}
