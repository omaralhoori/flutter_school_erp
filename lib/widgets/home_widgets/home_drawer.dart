import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.cog),
                  SizedBox(width: 5.0,),
                  Text("Settings"),
                ],
              ),
            ),
          ),
          Divider(),
          TextButton(
            onPressed: (){
              // TODO(hd02): Create logout action
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.signOutAlt),
                  SizedBox(width: 5.0,),
                  Text("Logout"),
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

