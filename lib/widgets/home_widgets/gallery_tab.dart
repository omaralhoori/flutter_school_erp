import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';

import 'album_card.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BaseView<HomeViewModel>(
      builder: (context, home, _) {
        return FutureBuilder(
          future: home.getAlbums(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  home.notifyGallery = true;
                  await home.getAlbums();
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //TODO: Hide filter when its empty (OK)
                        if ((home.filterOn
                                    ? home.filteredParentAlbums
                                    : home.parentAlbums)
                                .isNotEmpty ||
                            (home.filterOn ? home.filteredAlbums : home.albums)
                                .isNotEmpty)
                          Row(
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              TextButton(
                                onPressed: () {
                                  home.showAlertDialog(context);
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_alt),
                                      Text(
                                        tr('Filter'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if ((home.filterOn
                                ? home.filteredParentAlbums
                                : home.parentAlbums)
                            .isNotEmpty)
                          GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: (size.width / 180.0).round(),
                              ),
                              itemCount: (home.filterOn
                                      ? home.filteredParentAlbums
                                      : home.parentAlbums)
                                  .length,
                              itemBuilder: (ctxt, index) {
                                return AlbumCard(
                                  album: (home.filterOn
                                      ? home.filteredParentAlbums
                                      : home.parentAlbums)[index],
                                );
                              }),
                        if ((home.filterOn
                                ? home.filteredParentAlbums
                                : home.parentAlbums)
                            .isNotEmpty)
                          if ((home.filterOn
                                  ? home.filteredAlbums
                                  : home.albums)
                              .isNotEmpty)
                            Divider(),
                        if ((home.filterOn
                                ? home.filteredParentAlbums
                                : home.parentAlbums)
                            .isNotEmpty)
                          if ((home.filterOn
                                  ? home.filteredAlbums
                                  : home.albums)
                              .isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  tr("Other albums"),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (size.width / 180.0).round(),
                            ),
                            itemCount: (home.filterOn
                                    ? home.filteredAlbums
                                    : home.albums)
                                .length,
                            itemBuilder: (ctxt, index) {
                              return AlbumCard(
                                album: (home.filterOn
                                    ? home.filteredAlbums
                                    : home.albums)[index],
                              );
                            })
                      ],
                    ),
                  ),
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

class RankFilter extends StatefulWidget {
  final List<RankModel> rankList;
  final bool split;
  const RankFilter({Key? key, required this.rankList, this.split = false})
      : super(key: key);

  @override
  State<RankFilter> createState() => _RankFilterState();
}

class _RankFilterState extends State<RankFilter> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
          widget.rankList.length,
          (i) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: widget.rankList[i].isSelected,
                    onChanged: (value) {
                      setState(() {
                        widget.rankList[i].isSelected =
                            !widget.rankList[i].isSelected;
                      });
                      locator<HomeViewModel>()
                          .filterChanged(widget.rankList[i]);
                    },
                  ),
                  Text(widget.split
                      ? widget.rankList[i].text.split('-').last
                      : widget.rankList[i].text),
                ],
              )),
    );
  }
}
