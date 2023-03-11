import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_lock_security/data/enum/app_state_enum.dart';

import '../../providers/bloc_provider.dart';
import '../repo/app_state_local_storage_repo.dart';

//Change, Read, Write theme (Dark / Light) of App
class AppThemeBloc implements BlocBase {
  StreamController<AppThemeStateEnum> appStateBlocStreamController =
      StreamController<AppThemeStateEnum>();
  Stream<AppThemeStateEnum> get stream => appStateBlocStreamController.stream;

  AppThemeBloc() {
    readAppThemeStateFromLocalStorageAndEmitStream();
  }
  @override
  void dispose() {
    appStateBlocStreamController.close();
  }

  Future<void> readAppThemeStateFromLocalStorageAndEmitStream() async {
    final AppThemeStateEnum appThemeMode =
        await readAppThemeStateFromLocalStorage();

    if (appThemeMode == AppThemeStateEnum.dark) {
      appStateBlocStreamController.sink.add(AppThemeStateEnum.dark);
    } else {
      appStateBlocStreamController.sink.add(AppThemeStateEnum.light);
    }
  }

  Future<void> changeAppThemeStateAndEmitStream(bool isDarkMode) async {
    if (isDarkMode) {
      debugPrint(isDarkMode.toString());
      appStateBlocStreamController.sink.add(AppThemeStateEnum.dark);
      await saveAppThemeStateToLocalStorage(AppThemeStateEnum.dark);
    } else {
      debugPrint(isDarkMode.toString());
      appStateBlocStreamController.sink.add(AppThemeStateEnum.light);
      await saveAppThemeStateToLocalStorage(AppThemeStateEnum.light);
    }
  }
}

//App Auth State (logout, launch App , check App Authen)
class AppAuthStateBloc implements BlocBase {
  AppAuthStateBloc() {
    launchApp();
  }
  @override
  void dispose() {}
  //create Stream controler
  StreamController<AppAuthStateEnum> appStateStreamController =
      StreamController<AppAuthStateEnum>.broadcast();

  //getter stream from stream controller
  Stream<AppAuthStateEnum> get appAuthStateStream =>
      appStateStreamController.stream;

  //initial state
  AppAuthStateEnum get initAppAuthState => AppAuthStateEnum.loading;

  Future<void> launchApp() async {
    final AppAuthStateEnum appAuthState = await readAppAuthState();
    print(appAuthState.toString());

    if (appAuthState == AppAuthStateEnum.authorized) {
      appStateStreamController.sink.add(AppAuthStateEnum.authorized);
    } else {
      appStateStreamController.sink.add(AppAuthStateEnum.unAuthorized);
    }
  }

  Future<void> changeAppAuthState({required bool isUserTokenExpired}) async {
    if (isUserTokenExpired) {
      //expried = out date
      appStateStreamController.sink.add(AppAuthStateEnum.unAuthorized);
    } else {
      appStateStreamController.sink.add(AppAuthStateEnum.authorized);
    }
  }

  Future<void> logout() async {
    await saveAppAuthState(AppAuthStateEnum.unAuthorized);
    await changeAppAuthState(isUserTokenExpired: true);
  }
}
