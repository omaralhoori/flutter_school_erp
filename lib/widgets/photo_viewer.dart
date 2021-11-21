import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:school_erp/storage/config.dart';

class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    Key? key,
    required this.urls,
    required this.index,
  }) : super(key: key);
  final List<String> urls;
  final int index;

//Config.baseUrl +
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: urls.length,
      controller: PageController(initialPage: index),
      itemBuilder: (context, i){
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(Config.baseUrl + urls[i]),
        );
      },
    );
  }
}
