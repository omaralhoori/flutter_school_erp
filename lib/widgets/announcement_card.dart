import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_erp/model/announcement.dart';
import 'package:school_erp/model/config.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({Key? key, required this.announcement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0)
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            width: 300,
            child: Column(
              children: [
                Text(this.announcement.title),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${this.announcement.likes}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.thumbsUp,
                          size: 19,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${this.announcement.approvedComments}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.comment,
                          size: 19,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${this.announcement.views}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        FaIcon(
                          FontAwesomeIcons.eye,
                          size: 19,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
