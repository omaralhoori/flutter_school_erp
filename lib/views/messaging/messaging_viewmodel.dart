import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/message_type_enum.dart';
import 'package:school_erp/model/messaging/message.dart';
import 'package:school_erp/model/messaging/reply.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/messages_storage.dart';
import 'package:school_erp/utils/enums.dart';
import 'package:school_erp/views/base_viewmodel.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';

@lazySingleton
class MessagingViewModel extends BaseViewModel {
  List<Message> messages = [];
  List<Message> groupMessages = [];
  List<Message> directMessages = [];
  List<String> attachments = [];
  init() async {
    await getMessages();
  }

  Message? getMessageByName(String name) {
    for (Message msg in messages) {
      if (msg.name == name) {
        this.attachments = [];
        if (msg.attachments != null && msg.attachments != "")
          this.attachments = msg.attachments!.split(';');
        if (msg.thumbnail != null && msg.thumbnail != "")
          this.attachments.removeWhere((element) => element == msg.thumbnail);
        return msg;
      }
    }
  }

  Future<void> viewMessage(String messageName) async {
    await locator<Api>().viewMessage(messageName);
    for (Message msg in messages) {
      if (msg.name == messageName) {
        for (Reply reply in msg.replies) {
          if (reply.isAdministration == 1) {
            reply.isRead = 1;
          }
        }
        notifyListeners();
        locator<HomeViewModel>().getUnreadMessages();
        return;
      }
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
    try {
      messages = await locator<Api>().getMessages();
      try {
        await MessagesStorage.deleteMessages();
        MessagesStorage.putAllMessages(messages);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      messages = MessagesStorage.getMessages();
    }

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
