import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/home/home_viewmodel.dart';
import 'package:school_erp/views/home/student_tab.dart';
import 'package:school_erp/views/messaging/direct_messages_view.dart';
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
    bool rtlDir = context.locale.toString() == 'ar';
    return BaseView<HomeViewModel>(onModelReady: (model) {
      if (!Config().isGuest) model.getUnreadMessages();
    }, builder: (context, model, _) {
      return Scaffold(
        drawer: HomeDrawer(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: Palette.appBarIconsColor),
          child: SafeArea(
            child: DefaultTabController(
              length: !Config().isGuest ? 3 : 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
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
                            SizedBox(
                                width: 35.0,
                                height: 20.0,
                                child: Image.asset("assets/app_logo.png")),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, top: 3.0, right: 4.0),
                              child: Text(
                                tr("Alfityan School"),
                                style: TextStyle(
                                    color: Palette.appBarIconsColor,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        titlePadding: EdgeInsets.only(bottom: 13.0),
                      ),
                      actions: [
                        if (!Config().isGuest)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    NavigationHelper.push(
                                        context: context,
                                        page: DirectMessagesView());
                                  },
                                  icon: Icon(Icons.mail_outline)),
                              if (model.unreadDM > 0)
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${model.unreadDM}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                            ],
                          )
                      ],
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          indicatorColor: Palette.indicatorColor,
                          labelColor: Palette.appBarIconsColor,
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 25,
                                  ),
                                  Text(tr("Home")),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidImage,
                                    size: 25,
                                  ),
                                  Text(tr("Gallery")),
                                ],
                              ),
                            ),
                            if (!Config().isGuest)
                              Tab(
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.solidAddressBook,
                                          size: 25,
                                        ),
                                        Text(tr("Students")),
                                      ],
                                    ),
                                    if (model.unreadGM > 0)
                                      Positioned(
                                          top: 0,
                                          right: rtlDir ? null : 0,
                                          left: rtlDir ? 0 : null,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            alignment: Alignment.center,
                                          ))
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
                    if (!Config().isGuest) StudentTab(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
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
