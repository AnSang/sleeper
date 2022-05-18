import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleeper/models/user_info.dart';
import 'package:sleeper/utils/strings.dart';
import '../models/alarm_info.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_database.dart';

class AlarmNotification {
  final plugin = FlutterLocalNotificationsPlugin();

  /// init Notification
  Future initNotiSetting() async {
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await plugin.initialize( initSettings, onSelectNotification: onSelectNotification );
  }

  /// Set Notification
  Future dailyAtTimeNotification(AlarmInfo alarm, String fileName) async {
    int hour = int.parse(alarm.time.split(':')[0]);
    int min  = int.parse(alarm.time.split(':')[1]);

    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(now.year, now.month, now.day, hour, min);
    bool timeCheck = DateTime.now().isBefore(alarmTime);

    /// 우선 요일 체크하고, 현재시간 & 알람시간 비교해서 알람시간이 후에인지 체크
    if (checkDay(alarm) && timeCheck) {
      String notiDesc = '$hour시 $min분';
      String notiID = alarm.index.toString();

      var android = AndroidNotificationDetails(
          notiID,
          Word.ALARM,
          channelDescription: notiDesc,
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(fileName),
          priority: Priority.max
      );
      var ios = IOSNotificationDetails( sound: '$fileName.wav' );
      var detail = NotificationDetails( android: android, iOS: ios );

      await plugin.zonedSchedule(
          alarm.index,
          Word.ALARM,
          notiDesc,
          _setNotiTime(alarm.time),
          detail,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  /// 알람 삭제하기
  Future deleteAlarm(int alarmId) async {
    await plugin.cancel(alarmId);
  }

  /// 알람 전체 삭제하기
  Future deleteAllAlarm() async {
    await plugin.cancelAll();
  }

  /// 시간지정하기
  tz.TZDateTime _setNotiTime(String time) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final _time = time.split(':');

    final now = tz.TZDateTime.now(tz.local);
    final alarm = tz.TZDateTime(tz.local, now.year, now.month, now.day, int.parse(_time.first), int.parse(_time.last));
    // final alarm = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second + 3);

    return alarm;
  }

  bool checkDay(AlarmInfo info) {
    bool first = info.day.first;
    info.day.removeAt(0);
    info.day.add(first);

    int num = DateTime.now().weekday - 1;

    return info.day[num];
  }

  /// notification 눌렀을때
  Future onSelectNotification(String? payload) async {
    final FirebaseDataBase dataBase = FirebaseDataBase();
    UserInfoLocal info = await dataBase.getInfo();

    if (info.record.isEmpty) {  // 기록중인 데이터가 없다면 아무것도 안함
      return;
    } else {
      DateTime now = DateTime.now();
      String date = '${now.year}.${now.month}.${now.day}';
      String time = '${now.hour}:${now.minute}';
      dataBase.updateRecord(info.record, date, time);
    }
  }
}
