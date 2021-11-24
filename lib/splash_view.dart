import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'config/palette.dart';
import 'storage/config.dart';
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
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image(
                fit: BoxFit.contain, image: AssetImage('assets/home-hero.jpg')),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            tr("Welcome to our school."),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            tr("Lets get you started!"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              NavigationHelper.push(context: context, page: LoginView());
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.primaryButtonColor),
              child: Text(
                tr("Login"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          BaseView<LoginViewModel>(
            builder: (context, login, _) {
              return TextButton(
                onPressed: () async {
                  String deviceID = await Palette.deviceID();
                  login.updateUserDetails(LoginResponse(userId: deviceID));
                  // print(Config().userId);
                  Config.set('isGuest', true);
                  NavigationHelper.clearAllAndNavigateTo(
                      context: context, page: HomeView());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black54,
                      size: 14,
                    ),
                    Text(
                      tr("Skip"),
                      style: TextStyle(color: Colors.black54),
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
