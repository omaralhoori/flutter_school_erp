import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class ProfileViewModel extends BaseViewModel {
  String _email = "";
  String _fullName = "";

  String get email => _email;
  String get fullName => _fullName;

  setEmail(String email) {
    _email = email;
  }

  setFullName(String fullName) {
    _fullName = fullName;
  }

  init() async {
    await getUserData();
  }

  getUserData() async {
    UserData? userData = await locator<Api>().getUserData();
    if (userData != null) {
      setEmail(userData.email);
      setFullName(userData.fullName);
      notifyListeners();
    }
  }

  Future<UpdateProfileResponse> updateProfileData(UserData userData) async {
    UpdateProfileResponse response =
        await locator<Api>().updateUserProfile(userData);

    return response;
  }
}
