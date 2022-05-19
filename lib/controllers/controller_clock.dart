import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ClockController extends GetxController {
  var now = DateTime.now();
  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  var formattedDate = DateFormat('M월 d일 ').format(DateTime.now()) + getDay(DateTime.now());
  var timezoneString = DateTime.now().timeZoneOffset.toString().split('.').first;
  var offsetSign = '+';

  @override
  void onInit() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      formattedTime = DateFormat('HH:mm').format(now);
      formattedDate = DateFormat('M월 d일 ').format(now) + getDay(now);
      timezoneString = now.timeZoneOffset.toString().split('.').first;
      if (!timezoneString.startsWith('-')) offsetSign = '+';
      update();
    });
    super.onInit();
  }
}

String getDay(DateTime time) {
  String e = DateFormat('E').format(time);
  if (e.contains('Mon')) {
    return '월요일';
  } else if (e.contains('Tue')) {
    return '화요일';
  } else if (e.contains('Wed')) {
    return '수요일';
  } else if (e.contains('Thu')) {
    return '목요일';
  } else if (e.contains('Fri')) {
    return '금요일';
  } else if (e.contains('Sat')) {
    return '토요일';
  } else {
    return '일요일';
  }
}