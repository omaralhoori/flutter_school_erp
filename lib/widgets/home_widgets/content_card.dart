import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/views/content_preview/content_preview_view.dart';

import '../custom_slider.dart';
import '../interaction_button.dart';

class ContentCard extends StatelessWidget {
  final Content content;

  const ContentCard({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        // TODO(cc01): Add new page to show comments and News details
        Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPreviewView(content: content)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0)
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: size.width *.02),
        width: size.width,
        child: Column(
          children: [
            Text(
              this.content.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 3.0,),
            Text(
              Palette.postingTime(DateTime.parse(this.content.creation), context.locale.toString()),
              style: Theme.of(context).textTheme.caption,
            ),
            Html(
              data: this.content.description,
              onImageTap: (url, ctxt, attributes, element){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPreviewView(content: content)));
              },
              customImageRenders: {
                networkSourceMatcher(): networkImageRender(
                  headers: {"Custom-Header": "some-value"},
                  altWidget: (alt) => Text(alt ?? ""),
                  loadingWidget: () => Text("Loading..."),
                ), (attr, _) => attr["src"] != null && attr["src"]!.startsWith("/files"):
                networkImageRender(
                  mapUrl: (url) {
                    String imgUrl = Config().baseUrl!.endsWith('/')
                        ? url!.substring(1, url.length)
                        : url!;
                    return Config().baseUrl! + imgUrl;
                  },
                ),
              },
            ),
            CustomSlider(filesUrl: content.fileUrl.split(',')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: InteractionButton(
                    onPressed: this.content.isLiked == 0 ? () {
                      // TODO(cc02): Add like button action
                    } : null,
                    icon:
                    this.content.isLiked == 0
                        ? FontAwesomeIcons.heart
                        : FontAwesomeIcons.solidHeart,
                    count: this.content.likes,
                    color: this.content.isViewed == 0 ? Palette.interactionIconsColor : FrappePalette.red,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: InteractionButton(
                    onPressed: () {
                      // TODO(cc03): Add comments button action
                    },
                    icon: FontAwesomeIcons.comment,
                    count: this.content.approvedComments,
                    color: Palette.interactionIconsColor,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: InteractionButton(
                    onPressed: null,
                    icon: FontAwesomeIcons.eye,
                    count: this.content.views,
                    color: this.content.isViewed == 0 ? Palette.interactionIconsColor : Palette.interactionIconsColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




