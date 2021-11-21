import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/views/content_preview/content_preview_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_slider.dart';
import '../interaction_button.dart';

class ContentCard extends StatelessWidget {
  final int index;

  const ContentCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Content content = locator<HomeViewModel>().contentList[index];
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        // TODO(cc01): Add new page to show comments and News details
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContentPreviewView(index: index)));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
        padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: size.width * .02),
        width: size.width,
        child: Column(
          children: [
            Text(
              content.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 3.0,
            ),
            Text(
              "${tr(content.contentType)} " +
                  Palette.postingTime(DateTime.parse(content.creation),
                      context.locale.toString()),
              style: Theme.of(context).textTheme.caption,
            ),
            PostDescriptionHtml(content: content),
            if (content.fileUrl != '')
              CustomSlider(filesUrl: content.fileUrl.split(',')),
            PostButtons(content: content,),
          ],
        ),
      ),
    );
  }
}

class PostButtons extends StatefulWidget {
  const PostButtons({
    Key? key,
    required this.content,
  }) : super(key: key);

  final Content content;

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
              if (widget.content.isLiked == 0) {
                print('like');
                widget.content.isLiked = 1;
                widget.content.likes++;
                locator<HomeViewModel>().likePost(widget.content);
              } else {
                print('dislike');
                widget.content.isLiked = 0;
                widget.content.likes--;
                locator<HomeViewModel>().dislikePost(widget.content);
              }
              setState(() {});
            },
            icon: widget.content.isLiked == 0
                ? FontAwesomeIcons.heart
                : FontAwesomeIcons.solidHeart,
            count: widget.content.likes,
            color: widget.content.isLiked == 0
                ? Palette.interactionIconsColor
                : FrappePalette.red,
          ),
        ),
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: null,
            icon: FontAwesomeIcons.comment,
            count: widget.content.approvedComments,
            color: Palette.interactionIconsColor,
          ),
        ),
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: null,
            icon: FontAwesomeIcons.eye,
            count: widget.content.views,
            color: widget.content.isViewed == 1
                ? Palette.interactionIconsColor
                : Palette.interactionIconsColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class PostDescriptionHtml extends StatelessWidget {
  const PostDescriptionHtml({
    Key? key,
    required this.content,
  }) : super(key: key);

  final Content content;

  @override
  Widget build(BuildContext context) {
    return Html(
        data: this.content.description,
        style: {
          "table": Style(),
          "td": Style(
              border: Border.all(width: 0.5, color: Colors.black87),
              padding: EdgeInsets.all(5))
        },
        customImageRenders: {
          networkSourceMatcher(): networkImageRender(
            headers: {"Custom-Header": "some-value"},
            altWidget: (alt) => Text(alt ?? ""),
            loadingWidget: () => Text("Loading..."),
          ),
          (attr, _) => attr["src"] != null && attr["src"]!.startsWith("/files"):
              networkImageRender(
            mapUrl: (url) {
              String imgUrl = Config.baseUrl.endsWith('/')
                  ? url!.substring(1, url.length)
                  : url!;
              return Config.baseUrl + imgUrl;
            },
          ),
        },
        onLinkTap: (String? url, RenderContext context,
            Map<String, String> attributes, element) async {
          if (url != null) {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              print("Cant open $url");
            }
          }
        });
  }
}
