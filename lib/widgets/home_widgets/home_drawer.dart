import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/views/settings/settings_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(),
          TextButton(
            onPressed: (){
              // TODO(hd01): Create setting page
              Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsViews(),
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
                          color: Palette.appBarIconsColor.withOpacity(0.2),
                          border: Border.all(color: Palette.homeAppBarColor)
                      ),
                      alignment: Alignment.center,
                      child: FaIcon(FontAwesomeIcons.cog)),
                  SizedBox(width: 5.0,),
                  Text(tr("Settings")),
                ],
              ),
            ),
          ),
          Divider(),
          /*
          TextButton(
            onPressed: (){
              // TODO(hd02): Create logout action
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Palette.appBarIconsColor.withOpacity(0.2),
                          border: Border.all(color: Palette.homeAppBarColor)
                      ),
                      alignment: Alignment.center,
                      child: FaIcon(FontAwesomeIcons.info)),
                  SizedBox(width: 5.0,),
                  Text(tr("About")),
                ],
              ),
            ),
          ),
          Divider(),
          */
          TextButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(tr("Logout")),
                  content: Text(tr("Would you like to logout?")),
                  actions: [
                    TextButton(
                      child: Text(tr("No")),
                      onPressed:  () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(tr("Yes")),
                      onPressed:  () {
                        // TODO(hd02): Create logout
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
                      color: Palette.appBarIconsColor.withOpacity(0.2),
                      border: Border.all(color: Palette.homeAppBarColor)
                    ),
                    alignment: Alignment.center,
                    child: FaIcon(FontAwesomeIcons.signOutAlt),
                  ),
                  SizedBox(width: 5.0,),
                  Text(tr("Logout")),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

