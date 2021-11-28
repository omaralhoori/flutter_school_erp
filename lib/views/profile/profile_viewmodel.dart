import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:school_erp/app/locator.dart';
import 'package:school_erp/model/update_profile_response.dart';
import 'package:school_erp/model/user_data.dart';
import 'package:school_erp/services/api/api.dart';
import 'package:school_erp/storage/offline_storage.dart';
import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class ProfileViewModel extends BaseViewModel {
  String _email = "";
  String _fullName = "";
  String? _profileImage = "";

  String get email => _email;
  String get fullName => _fullName;
  String? get profileImage => _profileImage;

  setEmail(String email) {
    _email = email;
  }

  setFullName(String fullName) {
    _fullName = fullName;
  }

  setProfileImage(String? profileImage) {
    _profileImage = profileImage;
  }

  init() async {
    await getUserData();
  }

  getUserData() async {
    UserData? userData = await locator<Api>().getUserData();
    if (userData != null) {
      setEmail(userData.email);
      setFullName(userData.fullName);
      setProfileImage(userData.userImage);
      notifyListeners();
    }
  }

  Future<UpdateProfileResponse> updateProfileData(UserData userData) async {
    UpdateProfileResponse response =
        await locator<Api>().updateUserProfile(userData);

    return response;
  }

  Future<String?> uploadUserPorfileImage(XFile image) async {
    String? imageUrl = await locator<Api>().updateUserProfileImage(image);
    if (imageUrl != null) {
      OfflineStorage.putItem("userImage", imageUrl);
    }
    return imageUrl;
  }
}
