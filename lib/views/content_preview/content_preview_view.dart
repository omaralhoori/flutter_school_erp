import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/content_preview/content_preview_viewmodel.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/widgets/custom_slider.dart';
import 'package:school_erp/widgets/home_widgets/content_card.dart';
import 'package:school_erp/widgets/interaction_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  await model.fetchComments(content);
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
                      PostButtons(index: widget.index),
                      Divider(),
                      FutureBuilder(
                          future: model.fetchComments(content),
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
                              bool result =
                                  await model.addComment(content, comment);
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
  const CommentItem({Key? key, required this.comment, required this.senderName})
      : super(key: key);
  final String senderName;
  final String comment;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
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
              child: Text(comment),
            )
          ],
        ),
      ),
    );
  }
}
