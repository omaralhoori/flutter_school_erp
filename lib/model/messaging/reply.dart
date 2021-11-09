import 'package:hive/hive.dart';
part '../../adapters/reply.g.dart';

@HiveType(typeId: 4)
class Reply extends HiveObject {
  @HiveField(0)
  late String sendingDate;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String senderName;
  @HiveField(3)
  late String message;
  @HiveField(4)
  late int isRead;
  @HiveField(5)
  late int isAdministration;

  Reply({
    required this.sendingDate,
    required this.name,
    required this.senderName,
    required this.message,
    required this.isRead,
    required this.isAdministration,
  });

  Reply.fromJson(Map<String, dynamic> json) {
    sendingDate = json['sending_date'];
    name = json['name'];
    senderName = json['sender_name'];
    message = json['message'];
    isRead = json['is_read'];
    isAdministration = json['is_administration'];
  }
}
