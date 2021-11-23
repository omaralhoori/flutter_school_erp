import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/views/album_preview/album_preview_view.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      width: size.width,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          // TODO(ac01): Add new page to show comments and News details
          if (album.isViewed == 0) {
            try {
              locator<Api>().contentView(album.name, '');
              album.isViewed = 1;
              album.views++;
            } catch (e) {}
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AlbumPreviewView(
                        album: album,
                      )));


        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        Config.baseUrl + this.album.fileUrl.split(',').first),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(height: 3.0,),
            SizedBox(
              width: 140.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 17.0,
                    height: 17.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Palette.appBarIconsColor.withOpacity(0.3),
                        border: Border.all(color: Palette.appBarIconsColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      "${this.album.fileUrl.split(',').length}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    this.album.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
