import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/storage/config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:school_erp/utils/frappe_alert.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/content_preview/content_preview_view.dart';
import 'package:school_erp/views/content_preview/content_preview_viewmodel.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/widgets/interaction_button.dart';
import 'package:school_erp/widgets/photo_viewer.dart';

class AlbumPreviewView extends StatelessWidget {
  final Album album;
  const AlbumPreviewView({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("${album.fileUrl.split(',')}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          album.title,
          style: TextStyle(color: Palette.appbarForegroundColor),
        ),
        backgroundColor: Palette.appbarBackgroundColor,
        centerTitle: true,
        leading: BackButton(
          color: Palette.appbarForegroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (album.branch != null &&
                album.section != null &&
                album.branch != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RankCard(
                    rankType: RankType.Branch,
                    rankText: '${album.branch}',
                  ),
                  RankCard(
                    rankType: RankType.Section,
                    rankText: '${album.section!.split('-').last}',
                  ),
                  RankCard(
                    rankType: RankType.Class,
                    rankText: '${album.classCode}',
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${album.description}",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.start,
              ),
            ),
            Divider(),
            PostButtons(
              album: album,
            ),
            Divider(),
            Container(
              child: StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: this.album.fileUrl.split(',').length,
                itemBuilder: (context, i) => InkWell(
                  onTap: () {
                    NavigationHelper.push(
                        context: context,
                        page: PhotoViewer(
                          urls: this.album.fileUrl.split(','),
                          index: i,
                        ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: Config.baseUrl + this.album.fileUrl.split(',')[i],
                    fit: BoxFit.cover,
                  ),
                ),
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommentField extends StatefulWidget {
  final String name;
  const CommentField({Key? key, required this.name}) : super(key: key);

  @override
  _CommentFieldState createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      color: Colors.black,
      child: Container(
        padding: EdgeInsets.all(10.0),
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
                      label: tr("Message"), hint: tr("Write comment...")),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (_fbKey.currentState != null) {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        var formValue = _fbKey.currentState!.value;
                        String comment = formValue["message"] ?? '';
                        if (comment == '') return;
                        final model = locator<ContentPreviewViewModel>();
                        bool result =
                            await model.addComment(widget.name, '', comment);
                        if (!result) {
                          FrappeAlert.errorAlert(
                              title: tr("Something went wrong"),
                              context: context);
                        } else {
                          _fbKey.currentState!.patchValue({"message": ""});
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostButtons extends StatefulWidget {
  const PostButtons({
    Key? key,
    required this.album,
  }) : super(key: key);

  final Album album;

  @override
  _PostButtonsState createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: () {
              if (widget.album.isLiked == 0) {
                print('like');
                widget.album.isLiked = 1;
                widget.album.likes++;
                locator<HomeViewModel>().likePost(widget.album.name, '');
              } else {
                print('dislike');
                widget.album.isLiked = 0;
                widget.album.likes--;
                locator<HomeViewModel>().dislikePost(widget.album.name, '');
              }
              setState(() {});
            },
            icon: widget.album.isLiked == 0
                ? FontAwesomeIcons.heart
                : FontAwesomeIcons.solidHeart,
            count: widget.album.likes,
            color: widget.album.isLiked == 0
                ? Palette.interactionIconsColor
                : FrappePalette.red,
          ),
        ),
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  final model = locator<ContentPreviewViewModel>();
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CommentField(
                            name: widget.album.name,
                          ),
                          FutureBuilder(
                              future: model.fetchComments(
                                  widget.album.name, 'album'),
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
                                            comment:
                                                model.comments[index].comment,
                                          );
                                        })
                                    : CircularProgressIndicator();
                              }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: FontAwesomeIcons.comment,
            count: widget.album.approvedComments,
            color: Palette.interactionIconsColor,
          ),
        ),
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: null,
            icon: FontAwesomeIcons.eye,
            count: widget.album.views,
            color: widget.album.isViewed == 1
                ? Palette.interactionIconsColor
                : Palette.interactionIconsColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class RankCard extends StatelessWidget {
  final RankType rankType;
  final String rankText;
  const RankCard({
    Key? key,
    required this.rankText,
    required this.rankType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .33,
      decoration: BoxDecoration(
        color: rankType == RankType.Branch
            ? Colors.blue.shade100
            : rankType == RankType.Section
                ? Colors.green.shade100
                : rankType == RankType.Class
                    ? Colors.red.shade100
                    : Colors.blue.shade100,
        borderRadius: rankType == RankType.Branch
            ? BorderRadius.only(bottomRight: Radius.circular(25.0))
            : rankType == RankType.Section
                ? BorderRadius.only(
                    bottomRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0))
                : rankType == RankType.Class
                    ? BorderRadius.only(bottomLeft: Radius.circular(25.0))
                    : BorderRadius.circular(0.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 5.0,
          ),
          Text(
            rankType == RankType.Branch
                ? tr('Branch')
                : rankType == RankType.Section
                    ? tr('Section: ').replaceAll(':', '')
                    : rankType == RankType.Class
                        ? tr('Class: ').replaceAll(':', '')
                        : '',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
                color: rankType == RankType.Branch
                    ? Colors.blue.shade100
                    : rankType == RankType.Section
                        ? Colors.green.shade100
                        : rankType == RankType.Class
                            ? Colors.red.shade100
                            : Colors.blue.shade100,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(2, 0))
                ]),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                  child: Text(
                rankText,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

enum RankType {
  Branch,
  Section,
  Class,
}
