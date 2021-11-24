import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import '../views/content_preview/content_preview_viewmodel.dart' as _i9;
import '../views/payment/payment_viewmodel.dart' as _i10;
import '../views/student/student_viewmodel.dart' as _i11;
import '../views/messaging/messaging_viewmodel.dart' as _i12;
import '../views/login/login_viewmodel.dart' as _i14;
import '../views/home/home_viewmodel.dart' as _i13;
import '../services/storage_service.dart' as _i19;
import '../views/settings/settings_vewmodel.dart' as _i15;
import '../views/profile/profile_viewmodel.dart' as _i16;

_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);

  gh.lazySingleton<_i9.ContentPreviewViewModel>(
      () => _i9.ContentPreviewViewModel());
  gh.lazySingleton<_i10.PaymentViewModel>(() => _i10.PaymentViewModel());
  gh.lazySingleton<_i11.StudentViewModel>(() => _i11.StudentViewModel());
  gh.lazySingleton<_i12.MessagingViewModel>(() => _i12.MessagingViewModel());
  gh.lazySingleton<_i13.HomeViewModel>(() => _i13.HomeViewModel());
  gh.lazySingleton<_i14.LoginViewModel>(() => _i14.LoginViewModel());
  gh.lazySingleton<_i19.StorageService>(() => _i19.StorageService());
  gh.lazySingleton<_i15.SettingsViewModel>(() => _i15.SettingsViewModel());
  gh.lazySingleton<_i16.ProfileViewModel>(() => _i16.ProfileViewModel());

  return get;
}
