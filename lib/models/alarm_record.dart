class AlarmRecord {
  String sDate;   // 수면 시작날짜
  String sTime;   // 수면 시작시간
  String? eDate;   // 수면 종료날짜
  String? eTime;   // 수면 시작시간

  /// eDate, eTime 값은 나중에 설정해주기 때문에 Null 이 나타날수있다.

  AlarmRecord({
    required this.sDate,
    required this.sTime,
    required this.eDate,
    required this.eTime,
  });

  AlarmRecord.fromJson(Map<String, dynamic> json)
      : this(
      sDate: json['sDate']!,
      sTime: json['sTime']!,
      eDate: json['eDate'],
      eTime: json['eTime'],
  );

  Map<String, dynamic> toJson() {
    return {
      'sDate' : sDate,
      'sTime' : sTime,
      'eDate' : eDate,
      'eTime' : eTime
    };
  }
}