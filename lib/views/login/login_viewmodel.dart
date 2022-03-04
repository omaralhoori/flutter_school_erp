import 'package:school_erp/model/login/login_request.dart';
import 'package:school_erp/model/login/login_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/utils/dio_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:school_erp/utils/helpers.dart';
import 'package:school_erp/utils/http.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../storage/offline_storage.dart';
import '../../storage/config.dart';
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
      serverURL: Config.baseUrl,
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
      if (response.verification != null) {
        loginButtonLabel = "Verify";
        return response;
      } else {
        updateUserDetails(response);

        OfflineStorage.putItem(
          'usr',
          loginRequest.usr,
        );
        OfflineStorage.putItem(
          'pwd',
          loginRequest.pwd,
        );
        UserData? userData = await locator<Api>().getUserData();
        if (userData != null) {
          OfflineStorage.putItem(
            'fullName',
            userData.fullName,
          );
          OfflineStorage.putItem(
            'email',
            userData.email,
          );
          if (userData.userImage != null) {
            OfflineStorage.putItem(
              'userImage',
              userData.userImage,
            );
          }
        }
        Map? userType = await locator<Api>().getUserType();
        if (userType != null) {
          Config.set('isTeacher', userType["teacher"] ?? false);
          Config.set('isParent', userType["parent"] ?? false);
        }
        await updateDeviceToken();
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

  Future<void> loginMain() async {
    var usr = OfflineStorage.getItem("usr");
    var pwd = OfflineStorage.getItem("pwd");
    if (await verifyOnline()) {
      if (usr != null && pwd != null)
        try {
          LoginRequest loginRequest =
              LoginRequest(usr: usr["data"], pwd: pwd["data"]);
          var response = await locator<Api>().login(
            loginRequest,
          );
          if (response.verification != null) {
          } else {
            await Config.set('isLoggedIn', true);
            await DioHelper.initCookies();
          }
        } catch (e) {
          await Config.set('isLoggedIn', false);
        }
    }
  }
}
