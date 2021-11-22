import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
              print(home.parentAlbums);
              return RefreshIndicator(
                onRefresh: home.getAlbums,
                child: OrientationBuilder(
                  builder: (context, orientation){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 2,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 0
                                ),
                                itemCount: home.parentAlbums.length,
                                itemBuilder: (ctxt, index) {
                                  return AlbumCard(
                                    album: home.parentAlbums[index],
                                  );
                                }),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10.0,),
                              Text(tr("Other albums"), textAlign: TextAlign.start,),
                            ],
                          ),
                          Flexible(
                            flex: 3,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 0
                                ),
                                itemCount: home.albums.length,
                                itemBuilder: (ctxt, index) {
                                  return AlbumCard(
                                    album: home.albums[index],
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  },
                ),
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