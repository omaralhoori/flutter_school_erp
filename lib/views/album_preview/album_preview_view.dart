import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/model/album.dart';
import 'package:school_erp/model/config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class AlbumPreviewView extends StatelessWidget {
  final Album album;
  const AlbumPreviewView({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("${album.fileUrl.split(',')}");
    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
        centerTitle: true,
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
          Flexible(
            flex: 7,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: this.album.fileUrl.split(',').length,
              itemBuilder: (context, i) => InkWell(
                onTap: (){

                },
                child: CachedNetworkImage(
                  imageUrl: Config().baseUrl! + this.album.fileUrl.split(',')[i],
                  fit: BoxFit.cover,
                ),
              ),
              staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          )
        ],
      ),
    );
  }
}
