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
  getMessages() async {
    messages = await locator<Api>().getMessages();
  }

  Future<bool> addMessageReply(Message message, String reply) async {
    bool result = await locator<Api>().addMessageReply(reply, message.name);
    return result;
  }
}
