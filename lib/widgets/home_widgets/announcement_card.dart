import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/config.dart';

import '../interaction_button.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({Key? key, required this.announcement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        // TODO(f002): Add new page to show comments and News details
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0)
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: size.width *.05),
        width: size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(this.announcement.title,),
                SizedBox(width: 5.0,),
                Text(
                  postTime(DateTime.parse(this.announcement.creation)),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: FrappePalette.grey
                  ),
                ),
              ],
            ),
            Html(
              data: this.announcement.description,
              customImageRenders: {
                networkSourceMatcher(): networkImageRender(
                  headers: {"Custom-Header": "some-value"},
                  altWidget: (alt) => Text(alt ?? ""),
                  loadingWidget: () => Text("Loading..."),
                ),
                (attr, _) =>
                        attr["src"] != null &&
                        attr["src"]!.startsWith("/files"):
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InteractionButton(
                  onPressed: this.announcement.isLiked == 0 ? () {
                    // TODO(p03): Add like button action
                  } : null,
                  icon:
                  this.announcement.isLiked == 0
                      ? FontAwesomeIcons.heart
                      : FontAwesomeIcons.solidHeart,
                  count: this.announcement.likes,
                  color: FrappePalette.red,
                ),
                InteractionButton(
                  onPressed: () {
                    // TODO(p03): Add comments button action
                  },
                  icon: FontAwesomeIcons.comment,
                  count: this.announcement.approvedComments,
                  color: FrappePalette.red,
                ),
                InteractionButton(
                  onPressed: this.announcement.isViewed == 0 ? (){} : null,
                  icon: FontAwesomeIcons.eye,
                  count: this.announcement.views,
                  color: FrappePalette.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String postTime(DateTime date){
    Duration resultDuration = DateTime.now().difference(date);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if(resultDuration.inHours < 48){
      return "${resultDuration.inHours} hour ago";
    }else if(resultDuration.inHours < 72){
      return "${resultDuration.inDays} days ago";
    }else{
      return "${dateFormat.format(date)}";
    }
  }

}


