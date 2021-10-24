import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';

import 'album_card.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return FutureBuilder(
          future: home.getAlbums(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return RefreshIndicator(
                onRefresh: home.getAlbums,
                child: ListView.builder(
                    itemCount: home.albums.length,
                    itemBuilder: (ctxt, index) {

                      return AlbumCard(
                        album: home.albums[index],
                      );
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },

    );
  }
}