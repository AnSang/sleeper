import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleeper/controllers/controller_main.dart';
import 'package:sleeper/models/alarm_info.dart';
import 'package:sleeper/utils/notification.dart';

import '../utils/firebase_database.dart';

class AlarmController extends GetxController {
  static const key = 'alarm';

  FirebaseDataBase dataBase = Get.find<MainController>().dataBase;
  AlarmNotification noti = Get.find<MainController>().noti;

  TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);
  List<AlarmInfo> alarmList = [];
  List<bool> daySelect = List.filled(7, false);
  int isAlarmModify = -1;
  String alarmTimeString = '';
  DateTime alarmTime = DateTime.now();
  bool isAlarmCreate = false;

  @override
  void onInit() {
    timeOfDay = const TimeOfDay(hour: 12, minute: 00);
    alarmList = dataBase.alarmList;
    daySelect = List.filled(7, false);
    super.onInit();
  }

  void mModify(int index) { // 알람 수정화면 띄우기
    isAlarmCreate = true;
    isAlarmModify = index;
    timeOfDay = TimeOfDay(hour: int.parse(alarmList[index].time.split(':')[0]), minute: int.parse(alarmList[index].time.split(':')[1]));
    daySelect = alarmList[index].day.cast<bool>();
    update();
  }

  void mSave(int index) { // 알람 수정화면 > 등록
    String time = timeOfDay.toString().substring(10,15);
    alarmList[index] = (AlarmInfo(index: index, time: time, day: daySelect.toList(), isRun: true));

    // init
    isAlarmCreate = false;
    isAlarmModify = -1;
    initTimeOfDay();
    initDaySelect();
    update();
  }

  /// 알람시간 초기화
  void initTimeOfDay() {
    timeOfDay = const TimeOfDay(hour: 12, minute: 00);
    update();
  }

  /// 요일 선택하는것 초기화
  void initDaySelect() {
    daySelect.fillRange(0, daySelect.length, false);
    update();
  }

  /// Alarm 추가
  void addAlarm() async {
    setShowProgress(true);
    AlarmInfo alarm = AlarmInfo(index: alarmList.length, time: alarmTimeString, day: daySelect.toList(), isRun: true);
    await dataBase.addAlarm(alarm);
    await noti.dailyAtTimeNotification(alarm, dataBase.userInfoLocal.sound);
    await refreshAlarm();
    setShowProgress(false);
    update();
  }

  /// Alarm 삭제
  void delAlarm(int index) async {
    setShowProgress(true);
    await dataBase.deleteAlarm(index);
    await noti.deleteAlarm(index);
    await refreshAlarm();
    await dataBase.sortIndexAlarm();
    await refreshAlarm();
    setShowProgress(false);
    update();
  }

  /// Alarm List Refresh
  Future<void> refreshAlarm() async {
    dataBase.alarmList = await dataBase.getAlarmList();
    alarmList = dataBase.alarmList;
  }

  /// TimePicker 선택 후 저장
  void setTimePicker(TimeOfDay day) {
    final now = DateTime.now();
    final selectedDateTime = DateTime( now.year, now.month, now.day, day.hour, day.minute );
    alarmTime = selectedDateTime;
    alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
    update();
  }

  /// Switch로 On Off 설정
  void setBool(int index) async {
    setShowProgress(true);
    final check = alarmList[index].isRun = !alarmList[index].isRun;
    await dataBase.updateAlarm(alarmList[index]);
    if (check) {  // 알람이 활성화된 경우
      noti.dailyAtTimeNotification(dataBase.alarmList[index], dataBase.userInfoLocal.sound);
    } else {
      noti.deleteAlarm(index);
    }
    setShowProgress(false);
    update();
  }

  /// 알람추가 UI 띄울지 말지 설정
  void setIsCreate(bool bool) {
    isAlarmCreate = bool;
    update();
  }

  /// TimeOfDay 설정
  void setTimeOfDay(TimeOfDay time) {
    timeOfDay = time;
    update();
  }

  /// 요일선택 설정
  void setDaySelectItem(int index, int day) {
    alarmList[index].day[day] = !alarmList[index].day[day];
    update();
  }

  /// 요일 선택 설정
  void setDaySelect(int index) {
    daySelect[index] = !daySelect[index];
    update();
  }

  /// 요일 선택한게 있는지 체크
  bool checkDaySelect() {
    for (bool row in daySelect) {
      if (row) {
        return true;
      }
    }
    return false;
  }

  /// progress Indicator ON & OFF
  void setShowProgress(bool show) {
    Get.find<MainController>().setShowProgress(show);
    update();
  }

  /// 선택한 요일 String으로 반환
  String getDays(int index) {
    String day = '';
    for (int i = 0; i < alarmList[index].day.length; i++) {
      if (alarmList[index].day[i]) {
        if (i == 1) {
          day += '월 ';
        } else if (i == 2) {
          day += '화 ';
        } else if (i == 3) {
          day += '수 ';
        } else if (i == 4) {
          day += '목 ';
        } else if (i == 5) {
          day += '금 ';
        } else if (i == 6) {
          day += '토 ';
        } else if (i == 0) {
          day += '일 ';
        }
      }
    }
    return day;
  }
}