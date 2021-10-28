import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/widgets/interaction_button.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({Key? key, required this.album})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // TODO(ac01): Add new page to show comments and News details
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0)
            ),
            padding: EdgeInsets.zero,
            width: size.width,
            child: Column(
              children: [
                CachedNetworkImage(imageUrl: Config().baseUrl! + this.album.fileUrl.split(',').first),
                Text(this.album.title),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: InteractionButton(
                        onPressed: this.album.isLiked == 0 ? () {
                          // TODO(ac01): Add like button action
                        } : null,
                        icon:
                        this.album.isLiked == 0
                            ? FontAwesomeIcons.heart
                            : FontAwesomeIcons.solidHeart,
                        count: this.album.likes,
                        color: FrappePalette.mainSecondaryColor,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InteractionButton(
                        onPressed: () {
                          // TODO(ac02): Add comments button action
                        },
                        icon: FontAwesomeIcons.comment,
                        count: this.album.approvedComments,
                        color: FrappePalette.mainSecondaryColor,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InteractionButton(
                        onPressed: null,
                        icon: FontAwesomeIcons.eye,
                        count: this.album.views,
                        color: this.album.isViewed == 0 ? FrappePalette.mainSecondaryColor : FrappePalette.mainSecondaryColor.withOpacity(0.5),
                      ),
                    ),
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