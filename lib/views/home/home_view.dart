import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/frappe_palette.dart';
import 'package:school_erp/widgets/home_widgets/gallery_tab.dart';
import 'package:school_erp/widgets/home_widgets/home_drawer.dart';
import 'package:school_erp/widgets/home_widgets/news_tab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          endDrawer: HomeDrawer(),
          appBar: AppBar(
            backgroundColor: FrappePalette.red,
            bottom: TabBar(
              indicatorColor: FrappePalette.red.shade600,
              onTap: (val){

              },
              labelColor: FrappePalette.grey.shade50,
              tabs: [
                Tab(
                  text: tr("News"),
                ),
                Tab(
                  text: tr("Gallery"),
                ),
              ],
            ),
            // TODO(h01): Activating logo icon
            /*leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/frappe_icon.jpg"),
            ),*/
            title: Text(tr("Latest Updates")),
          ),
          body: TabBarView(
            children: [
              NewsTab(),
              GalleryTab(),
            ],
          ),
        ),
      ),
    );
  }
}




