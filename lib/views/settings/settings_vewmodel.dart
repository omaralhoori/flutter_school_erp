import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:school_erp/views/base_viewmodel.dart';

@lazySingleton
class SettingsViewModel extends BaseViewModel{
  String? _chosenValue;
  String? get chosenValue => _chosenValue;
  set chosenValue(String? val) {
    _chosenValue = val;
    notifyListeners();
  }


  String? buildNumber;

  List<String> items = [
    "en",
    "ar"
  ];

  SettingsViewModel(){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      buildNumber = packageInfo.version;
      notifyListeners();
    });
  }
}