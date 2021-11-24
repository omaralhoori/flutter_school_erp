import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/utils/helpers.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/views/contact_view.dart';
import 'package:school_erp/views/login/login_view.dart';
import 'package:school_erp/views/profile/profile_view.dart';
import 'package:school_erp/views/settings/settings_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: Image(
                  width: 180,
                  height: 120,
                  image: AssetImage('assets/app_logo.png')),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!Config().isGuest) Divider(),
                if (!Config().isGuest)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileView(),
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Palette.homeAppBarColor)),
                              alignment: Alignment.center,
                              child: FaIcon(FontAwesomeIcons.user)),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(tr("Profile")),
                        ],
                      ),
                    ),
                  ),
                Divider(),
                TextButton(
                  onPressed: () {
                    NavigationHelper.push(
                        context: context, page: ContactView());
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Palette.homeAppBarColor)),
                          alignment: Alignment.center,
                          child: Icon(Icons.mail_rounded),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(tr("Contact")),
                      ],
                    ),
                  ),
                ),
                Divider(),
                TextButton(
                  onPressed: () {
                    NavigationHelper.push(
                        context: context, page: SettingsViews());
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Palette.homeAppBarColor)),
                            alignment: Alignment.center,
                            child: FaIcon(FontAwesomeIcons.cog)),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(tr("Settings")),
                      ],
                    ),
                  ),
                ),
                Divider(),
                if (!Config().isGuest)
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(tr("Logout")),
                          content: Text(tr("Would you like to logout?")),
                          actions: [
                            TextButton(
                              child: Text(tr("No")),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(tr("Yes")),
                              onPressed: () async {
                                await clearLoginInfo();
                                NavigationHelper.clearAllAndNavigateTo(
                                  context: context,
                                  page: LoginView(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Palette.homeAppBarColor)),
                            alignment: Alignment.center,
                            child: FaIcon(FontAwesomeIcons.signOutAlt),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(tr("Logout")),
                        ],
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      NavigationHelper.push(
                          context: context, page: LoginView());
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Palette.homeAppBarColor)),
                            alignment: Alignment.center,
                            child: FaIcon(FontAwesomeIcons.signInAlt),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(tr("Login")),
                        ],
                      ),
                    ),
                  ),
                Divider(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
