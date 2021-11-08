import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'config/palette.dart';
import 'model/config.dart';
import 'model/login/login_response.dart';
import 'utils/navigation_helper.dart';
import 'views/base_view.dart';
import 'views/home/home_view.dart';
import 'views/login/login_view.dart';
import 'views/login/login_viewmodel.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Palette.fontColorPrimary,
            Palette.indicatorColor,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: (){
              NavigationHelper.push(context: context, page: LoginView());
            },
            child: Container(
              width: size.width * .6,
              height: size.width * .1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Palette.appBarIconsColor,
                    Palette.indicatorColor,
                  ]
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                tr("Login"),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          SizedBox(
            height: size.height * .35,
          ),
          BaseView<LoginViewModel>(
            builder: (context, login, _){
              return TextButton(
                onPressed: () async{
                  String deviceID = await Palette.deviceID();
                  login.updateUserDetails(LoginResponse(userId: deviceID));
                  // print(Config().userId);
                  Config.set('isGuest', true);
                  NavigationHelper.clearAllAndNavigateTo(context: context, page: HomeView());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Palette.homeAppBarColor,
                    ),
                    Text(
                      tr("Skip"),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
