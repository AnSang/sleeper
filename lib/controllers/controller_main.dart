import 'package:get/get.dart';
import 'package:sleeper/screens/screen_alarm.dart';
import 'package:sleeper/screens/screen_clock.dart';
import 'package:sleeper/screens/screen_info.dart';
import 'package:sleeper/screens/screen_record.dart';
import 'package:sleeper/utils/background_service.dart';
import 'package:sleeper/utils/firebase_database.dart';
import 'package:sleeper/utils/notification.dart';

import '../models/alarm_info.dart';

class MainController extends GetxController {
  static const key = 'Main';
  List screens = [ ScreenClock(), ScreenAlarm(), ScreenRecord(), ScreenInfo() ]; // Screen List

  final FirebaseDataBase dataBase = FirebaseDataBase();
  final BackGroundService service = BackGroundService();
  final AlarmNotification noti = AlarmNotification();

  var showScreenIndex = 0;            // Screen List, Menu List   Index
  bool isShowProgress = false;

  @override
  void onInit() async {
    setShowProgress(true);
    await noti.initNotiSetting();
    dataBase.userInfoLocal = await dataBase.getInfo();       // UserInfoLocal
    dataBase.alarmList = await dataBase.getAlarmList();
    for (AlarmInfo row in dataBase.alarmList) {
      if (row.isRun) {    /// 실행하기로 되어있는지 체크
        noti.dailyAtTimeNotification(row, dataBase.userInfoLocal.sound);
      }
    }
    await dataBase.downloadFile();
    setShowProgress(false);
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    await service.initializeService();
    super.onReady();
  }

  void setScreen(int index) {
    showScreenIndex = index;
    update();
  }

  /// progress Indicator ON & OFF
  void setShowProgress(bool show) {
    isShowProgress = show;
    update();
  }
}