import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class MessagingViewModel extends BaseViewModel {
  List<Message> messages = [];
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
