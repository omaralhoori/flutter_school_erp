import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/comment.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/posts_storage.dart';

import '../base_viewmodel.dart';

@lazySingleton
class ContentPreviewViewModel extends BaseViewModel {
  Content? _content;
  List<Comment> comments = [];
  Content? get content => _content;

  Future<bool> getContent(String name, String type) async {
    try {
      Content? _content =
      await locator<Api>().getContent(name, type);
      this._content = _content;
      // notifyListeners();
      if (this._content != null) {
        try {
          PostsStorage.putContent(this._content!);
        } catch (e) {
          print(e);
        }
      }
    } catch (dioError) {
      this._content = PostsStorage.getItem(name, type);
    }
    return Future.value(true);
  }

  void setContent(Content content) {
    _content = content;
    notifyListeners();
  }

  Future<bool> fetchComments(String name, String type) async {
    try {
      comments = await locator<Api>().getContentComments(name, type);
    } catch (e) {}
    return true;
  }

  Future<bool> addComment(String name, String type, String comment) async {
    try {
      return await locator<Api>().addContentComment(name, type, comment);
    } catch (e) {}
    return false;
  }
}
