import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class MessagingViewModel extends BaseViewModel {
  List<Message> messages = [];
  List<Message> groupMessages = [];
  List<Message> directMessages = [];
  init() async {
    await getMessages();
  }

  Message? getMessageByName(String name) {
    for (Message msg in messages) {
      if (msg.name == name) return msg;
    }
  }
  // Future<Message> fetchMessage(String name){

  // }

  Future<bool> getGroupMessages(String studentNo) async {
    await this.getMessages();
    groupMessages = messages.where((e) => e.studentNo == studentNo).toList();
    return true;
  }

  Future<bool> getDirectMessages() async {
    await this.getMessages();
    directMessages =
        messages.where((e) => e.messageType == MessageType.direct).toList();
    return true;
  }

  Future<bool> getMessages() async {
    messages = await locator<Api>().getMessages();
    //notifyListeners();
    return true;
  }

  Future<String> addMessageReply(Message message, String reply) async {
    String result = await locator<Api>().addMessageReply(reply, message.name);
    return result;
  }

  Future<bool> deleteReplies(String message, String replies) async {
    bool result = await locator<Api>().deleteMessageRpelies(message, replies);
    return result;
  }
}
