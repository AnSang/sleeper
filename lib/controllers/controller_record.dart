import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleeper/models/alarm_record.dart';

import '../utils/firebase_database.dart';
import 'controller_main.dart';

class RecordController extends GetxController {
  List<AlarmRecord> recordList = [];
  List<DateTimeRange> showItems = [];
  bool check = false;
  bool btnStart = false;
  bool btnEnd = false;

  FirebaseDataBase dataBase = Get.find<MainController>().dataBase;

  @override
  void onInit() async {
    recordList = await dataBase.getRecordList(); // 기록 data 가져오기
    await setButtonBool();
    showItems = getItem();
    check = true;
    update();
    super.onInit();
  }

  /// 수면시작 버튼 event
  Future startRecord() async {  // 수면 시작
    setShowProgress(true);
    DateTime now = DateTime.now();
    String date = '${now.year}.${now.month}.${now.day}';
    String time = '${now.hour}:${now.minute}';
    dataBase.userInfoLocal.record = date;

    await dataBase.addRecord(date, time);
    await dataBase.updateInfo(dataBase.userInfoLocal);
    await setButtonBool();
    setShowProgress(false);
    update();
  }

  /// 수면종료 버튼 event
  Future endRecord() async {  // 수면 종료
    setShowProgress(true);
    DateTime now = DateTime.now();
    String date = '${now.year}.${now.month}.${now.day}';
    String time = '${now.hour}:${now.minute}';

    await dataBase.updateRecord(dataBase.userInfoLocal.record, date, time);
    dataBase.userInfoLocal.record = '';   // 수면 종료 처리
    await dataBase.updateInfo(dataBase.userInfoLocal);
    await setButtonBool();
    setShowProgress(false);
    update();
  }

  /// progress Indicator ON & OFF
  void setShowProgress(bool show) {
    Get.find<MainController>().setShowProgress(show);
    update();
  }

  /// showDate convert to '2022.4'
  String getMonth(DateTime date) {
    return DateFormat('yyyy.M').format(date);
  }

  /// 수면시작, 수면종료 버튼 활성화
  Future setButtonBool() async {
    DateTime now = DateTime.now();
    String date = '${now.year}.${now.month}.${now.day}';
    AlarmRecord? toDay = await dataBase.getRecordDate(date);

    if (toDay == null) {                            // 그날의 알람기록이 없을때
      if (dataBase.userInfoLocal.record.isEmpty) {  // 기록도 없고 기록중이지 않을때
        btnStart = true; btnEnd = false;
      } else {                                      // 그날의 알람기록은 없으나 현재 수면 체크중인 데이터가 있는 경우
        btnStart = false; btnEnd = true;
      }
    } else {                                        // 그날의 알람기록이 있는 경우
      if (dataBase.userInfoLocal.record.isEmpty) {  // 그날에 알람기록을 마친 경우
        btnStart = false; btnEnd = false;
      } else {                                      // 아마 대부분이 그날의 알람기록을 종료하는 경우
        btnStart = false; btnEnd = true;
      }
    }
  }

  List<DateTimeRange> getItem() {
    List<DateTimeRange> list = [];
    for (AlarmRecord row in recordList) {
      if (row.eDate != null && row.eTime != null) {
        List<String> sDate = row.sDate.split('.');
        List<String> sTime = row.sTime.split(':');
        List<String> eDate = row.eDate!.split('.');
        List<String> eTime = row.eTime!.split(':');

        DateTime start = DateTime(int.parse(sDate[0]), int.parse(sDate[1]), int.parse(sDate[2]), int.parse(sTime.first), int.parse(sTime.last));
        DateTime end = DateTime(int.parse(eDate[0]), int.parse(eDate[1]), int.parse(eDate[2]), int.parse(eTime.first), int.parse(eTime.last));
        list.add(DateTimeRange(start: start, end: end));
      }
    }
    list.sort((a, b) => b.start.compareTo(a.start));
    return list;
  }
}