import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/enum/app_state_enum.dart';
import '../../../data/term/local_storage_pref_key.dart';

//read AppThemeState From LocalStorage
Future<AppThemeStateEnum> readAppThemeStateFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final String? appThemeMode = prefs.getString(SharedPrefsKey.appThemeMode);

  if (appThemeMode == AppThemeStateEnum.dark.toString()) {
    return AppThemeStateEnum.dark;
  } else {
    return AppThemeStateEnum.light;
  }
}

//save AppThemeState To LocalStorage
Future<void> saveAppThemeStateToLocalStorage(
    AppThemeStateEnum appThemeStateEnum) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      SharedPrefsKey.appThemeMode, appThemeStateEnum.toString());
}

//read AppAuthState
Future<AppAuthStateEnum> readAppAuthState() async {
  final prefs = await SharedPreferences.getInstance();
  final String? appLoginState =
      prefs.getString(SharedPrefsKey.appAuthState.toString());

  if (appLoginState == AppAuthStateEnum.authorized.toString()) {
    return AppAuthStateEnum.authorized;
  } else {
    return AppAuthStateEnum.unAuthorized;
  }
}

// save AppAuthState
Future<void> saveAppAuthState(AppAuthStateEnum appAuthStateEnum) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      SharedPrefsKey.appAuthState, appAuthStateEnum.toString());
}
