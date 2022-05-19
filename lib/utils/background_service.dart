import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sleeper/firebase_options.dart';
import 'package:sleeper/models/alarm_info.dart';
import 'package:sleeper/models/user_info.dart';
import 'package:sleeper/utils/firebase_database.dart';
import 'package:sleeper/utils/notification.dart';

class BackGroundService {
  final FlutterBackgroundService service = FlutterBackgroundService();

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }
}

bool onIosBackground(ServiceInstance service) {
  print('FLUTTER BACKGROUND FETCH');
  return true;
}

Future onStart(ServiceInstance service) async {
  /*await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform );
  final AlarmNotification noti = AlarmNotification();
  final FirebaseDataBase dataBase = FirebaseDataBase();
  noti.initNotiSetting();

  *//*if (service is AndroidServiceInstance) {
    service.setAsBackgroundService();

    service.on('fg').listen((event) {
      service.setAsForegroundService();
    });

    service.on('bg').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stop').listen((event) {
    service.stopSelf();
  });*//*

  /// 처리할 함수들 여기 작성
  Timer.periodic(const Duration(hours: 1), (timer) async {
    await noti.deleteAllAlarm(); // 알람 전체 삭제
    UserInfoLocal info = await dataBase.getInfo();
    List<AlarmInfo> list = await dataBase.getAlarmList();

    for (AlarmInfo alarm in list) {
      if (alarm.isRun) {
        noti.dailyAtTimeNotification(alarm, info.sound);
      }
    }
  });*/
}