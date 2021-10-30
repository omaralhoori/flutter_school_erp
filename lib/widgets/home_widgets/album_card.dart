import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/config.dart';
import 'package:school_erp/views/album_preview/album_preview_view.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({Key? key, required this.album})
      : super(key: key);

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumPreviewView(album: album,)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(Config().baseUrl! + this.album.fileUrl.split(',').first),
                    fit: BoxFit.fill
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 17.0,
                  height: 17.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                  ),
                  child: Text(
                    "${this.album.fileUrl.split(',').length}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              ),
            Text(
              this.album.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

