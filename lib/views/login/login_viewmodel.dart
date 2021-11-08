import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:injectable/injectable.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../model/offline_storage.dart';
import '../../model/config.dart';
import '../../views/base_viewmodel.dart';

class SavedCredentials {
  String? serverURL;
  String? usr;

  SavedCredentials({
    this.serverURL,
    this.usr,
  });
}

@lazySingleton
class LoginViewModel extends BaseViewModel {
  var savedCreds = SavedCredentials();

  late String loginButtonLabel;

  init() {
    loginButtonLabel = "Login";

    savedCreds = SavedCredentials(
      serverURL: Config().baseUrl,
      usr: OfflineStorage.getItem('usr')["data"],
    );
  }

  updateUserDetails(LoginResponse response) {
    Config.set('isLoggedIn', true);

    Config.set(
      'userId',
      response.userId,
    );
    Config.set(
      'user',
      response.fullName,
    );
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    loginButtonLabel = "Verifying...";
    notifyListeners();

    try {
      var response = await locator<Api>().login(
        loginRequest,
      );
      print(response);
      print("Test");
      if (response.verification != null) {
        loginButtonLabel = "Verify";
        return response;
      } else {
        updateUserDetails(response);

        OfflineStorage.putItem(
          'usr',
          loginRequest.usr,
        );

        // await cacheAllUsers();
        await DioHelper.initCookies();

        loginButtonLabel = "Success";
        notifyListeners();

        return response;
      }
    } catch (e) {
      Config.set('isLoggedIn', false);
      loginButtonLabel = "Login";
      notifyListeners();
      throw e;
    }
  }
}
