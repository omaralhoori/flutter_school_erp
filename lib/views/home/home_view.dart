import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/widgets/home_widgets/contact_tab.dart';
import 'package:school_erp/widgets/home_widgets/gallery_tab.dart';
import 'package:school_erp/widgets/home_widgets/home_drawer.dart';
import 'package:school_erp/widgets/home_widgets/content_tab.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Palette.appBarIconsColor),
        child: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Palette.homeAppBarColor,
                    expandedHeight: 60.0,
                    iconTheme: IconThemeData(color: Palette.appBarIconsColor),
                    floating: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 30.0,height: 20.0, child: Image.asset("assets/frappe_icon.jpg")),
                          Text(
                            tr("Latest Updates"),
                            style: TextStyle(
                                color: Palette.appBarIconsColor,
                                fontSize: 13
                            ),
                          ),
                        ],
                      ),
                      titlePadding: EdgeInsets.only(bottom: 13.0),
                    ),

                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        indicatorColor: Palette.indicatorColor,
                        labelColor: Palette.appBarIconsColor,
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home, size: 25,),
                                Text(tr("News")),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FaIcon(FontAwesomeIcons.solidImage, size: 25,),
                                Text(tr("Gallery")),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FaIcon(FontAwesomeIcons.solidAddressBook, size: 25,),
                                Text(tr("Contact")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  ContentTab(),
                  GalleryTab(),
                  ContactTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Palette.homeAppBarColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}