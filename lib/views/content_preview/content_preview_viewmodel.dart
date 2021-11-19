import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/comment.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/services/api/api.dart';

import '../base_viewmodel.dart';

@lazySingleton
class ContentPreviewViewModel extends BaseViewModel {
  Content? _content;
  List<Comment> comments = [];
  Content? get content => _content;

  void setContent(Content content) {
    _content = content;
    notifyListeners();
  }

  Future<bool> fetchComments(Content content) async {
    try {
      comments = await locator<Api>().getContentComments(content);
    } catch (e) {}
    return true;
  }

  Future<bool> addComment(Content content, String comment) async {
    try {
      return await locator<Api>().addContentComment(content, comment);
    } catch (e) {}
    return false;
  }
}
