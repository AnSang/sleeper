class AlarmInfo {
  int index;              /// 알람 index
  String time;            /// 시간
  List<dynamic> day;      /// 일,월,화,수,목,금,토
  bool isRun = false;     /// 알람 실행할지
  String? document;       /// FireStore Doc Id

  AlarmInfo({
    required this.index,
    required this.time,
    required this.day,
    required this.isRun
  });

  AlarmInfo.fromJson(Map<String, Object?> json)
      : this(
        index: json['index']! as int,
        time: json['time']! as String,
        day: json['day']! as List<dynamic>,
        isRun: json['isRun']! as bool
  );

  Map<String, Object?> toJson() {
    return {
      'index' : index,
      'time' : time,
      'day' : day,
      'isRun' : isRun
    };
  }

  @override
  String toString() {
    return '"AlarmInfo" : { "index": $index, "time": $time, "day": $day, "isRun" : $isRun}';
  }
}