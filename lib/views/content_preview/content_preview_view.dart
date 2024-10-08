import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/content_preview/content_preview_viewmodel.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/widgets/custom_slider.dart';
import 'package:school_erp/widgets/home_widgets/content_card.dart';

class ContentPreviewView extends StatefulWidget {
  final int index;
  const ContentPreviewView({Key? key, required this.index}) : super(key: key);

  @override
  _ContentPreviewViewState createState() => _ContentPreviewViewState();
}

class _ContentPreviewViewState extends State<ContentPreviewView> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    Content content = locator<HomeViewModel>().contentList[widget.index];
    return BaseView<ContentPreviewViewModel>(
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.appbarBackgroundColor,
            leading: BackButton(
              color: Palette.appbarForegroundColor,
            ),
            title: Text(
              content.title,
              style: Theme.of(context).textTheme.bodyText2!.apply(
                    color: Palette.homeAppBarColor,
                    fontSizeDelta: 3,
                  ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  await model.fetchComments(content.name, content.contentType);
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${tr(content.contentType)} " +
                            Palette.postingTime(
                                DateTime.parse(content.creation),
                                context.locale.toString()),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      PostDescriptionHtml(content: content),
                      if (content.fileUrl != '')
                        CustomSlider(filesUrl: content.fileUrl.split(',')),
                      Divider(),
                      PostButtons(
                        content: content,
                      ),
                      Divider(),
                      FutureBuilder(
                          future: model.fetchComments(
                              content.name, content.contentType),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    physics: BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    padding: EdgeInsets.all(10),
                                    itemCount: model.comments.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return CommentItem(
                                        senderName:
                                            model.comments[index].userName,
                                        comment: model.comments[index].comment,
                                        userImage:
                                            model.comments[index].userImage,
                                      );
                                    })
                                : CircularProgressIndicator();
                          })
                    ],
                  ),
                ),
              )),
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: FormBuilder(
                  key: _fbKey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'message',
                          decoration: Palette.formFieldDecoration(
                              label: tr("Message"),
                              hint: tr("Write comment...")),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (_fbKey.currentState != null) {
                            if (_fbKey.currentState!.saveAndValidate()) {
                              var formValue = _fbKey.currentState!.value;
                              String comment = formValue["message"] ?? '';
                              if (comment == '') return;
                              bool result = await model.addComment(
                                  content.name, content.contentType, comment);
                              if (!result) {
                                FrappeAlert.errorAlert(
                                    title: tr("Something went wrong"),
                                    context: context);
                              } else {
                                _fbKey.currentState!
                                    .patchValue({"message": ""});
                                setState(() {});
                                FrappeAlert.successAlert(
                                    title: tr("Comment added successfully"),
                                    context: context);
                              }
                            }
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Palette.primaryButtonColor,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem(
      {Key? key,
      required this.comment,
      required this.senderName,
      this.userImage})
      : super(key: key);
  final String senderName;
  final String comment;
  final String? userImage;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ClipOval(
                child: (userImage != null && userImage != "")
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        imageUrl: Config.baseUrl + userImage!)
                    : Image(
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/user-avatar.png"),
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      senderName,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      comment,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
