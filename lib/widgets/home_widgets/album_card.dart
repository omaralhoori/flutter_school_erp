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
    final double cellSized = 120; //(size.width / (size.width / 180.0)) - 60;
    return InkWell(
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: cellSized,
                height: cellSized,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cellSized / 4),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          Config.baseUrl + this.album.fileUrl.split(',').first),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: cellSized / 7,
                    // height: cellSized / 7,
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
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
                  SizedBox(
                    width: cellSized / 8,
                  ),
                  Flexible(
                    child: Text(
                      this.album.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
