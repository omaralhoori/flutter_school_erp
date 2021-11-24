import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/storage/config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:school_erp/utils/navigation_helper.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "${tr("Description")}: ${album.description}",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Divider(),
          PostButtons(album: album,),
          Divider(),
          Flexible(
            flex: 7,
            child: StaggeredGridView.countBuilder(
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
        /*
        Flexible(
          flex: 1,
          child: InteractionButton(
            onPressed: null,
            icon: FontAwesomeIcons.comment,
            count: widget.album.approvedComments,
            color: Palette.interactionIconsColor,
          ),
        ),
        */
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