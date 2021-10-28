import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/model/content.dart';
import 'package:school_erp/widgets/interaction_button.dart';

class ContentPreviewView extends StatelessWidget {
  final Content content;
  const ContentPreviewView({Key? key, required this.content}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height*.05,
            ),
            Text(this.content.title),
            Html(
              data: this.content.description,
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
            Divider(),
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
                    color: FrappePalette.red,
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
                    color: FrappePalette.red,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: InteractionButton(
                    onPressed: null,
                    icon: FontAwesomeIcons.eye,
                    count: this.content.views,
                    color: this.content.isViewed == 0 ? FrappePalette.red : FrappePalette.grey,
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              height: 300.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.black)
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: (){

                            },
                            icon: Icon(Icons.send),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
