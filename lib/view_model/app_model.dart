import 'dart:io';

import 'package:flutter/material.dart';
import '/config/net/pgyer_api.dart';
import '/provider/view_state_model.dart';
import '/service/app_repository.dart';
import '/utils/platform_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kAppFirstEntry = 'kAppFirstEntry';

// 主要用于app启动相关
class AppModel with ChangeNotifier {
  bool? isFirst = false;

  loadIsFirstEntry() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    isFirst = sharedPreferences.getBool(kAppFirstEntry);
    notifyListeners();
  }
}

class AppUpdateModel extends ViewStateModel {
  Future<AppUpdateInfo?> checkUpdate() async {
    AppUpdateInfo? appUpdateInfo;
    setBusy();
    try {
      var appVersion = await PlatformUtils.getAppVersion();
      appUpdateInfo =
          await AppRepository.checkUpdate(Platform.operatingSystem, appVersion);
      setIdle();
    } catch (e, s) {
      setError(e,s);
    }
    return appUpdateInfo;
  }
}
