import 'package:hive/hive.dart';
import 'package:school_erp/model/message_type_enum.dart';
import 'package:school_erp/model/messaging/reply.dart';
import 'package:school_erp/utils/helpers.dart';
part '../../adapters/message.g.dart';

@HiveType(typeId: 5)
class Message extends HiveObject {
  @HiveField(0)
  late String creation;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late MessageType messageType;
  @HiveField(3)
  late String messageName;
  @HiveField(4)
  late String title;
  @HiveField(5)
  late String? studentNo;
  @HiveField(6)
  late String? studentName;
  @HiveField(7)
  late List<Reply> replies;
  @HiveField(8)
  late String? thumbnail;
  @HiveField(9)
  late String? attachments;

  Message({
    required this.creation,
    required this.name,
    required this.messageType,
    required this.messageName,
    required this.title,
    required this.replies,
    this.studentNo,
    this.studentName,
    this.thumbnail,
    this.attachments,
  });

  Message.fromJson(Map<String, dynamic> json) {
    creation = json['creation'];
    name = json['name'];
    messageType = getMessageType(json["message_type"]);
    title = json['title'];
    messageName = json['message_name'];
    studentNo = json['student_no'];
    studentName = json['student_name'];
    thumbnail = json['thumbnail'];
    attachments = json['attachments'];
    Iterable i = json["messages"];
    replies = List.from(i.map((message) => Reply.fromJson(message)));
    // for (var message in json["messages"]) {
    //   replies.add(Reply.fromJson(message));
    // }
  }
}
