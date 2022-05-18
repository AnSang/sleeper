class UserInfoLocal {
  String name;      /// 닉네임
  // double volume;    /// 알람 볼륨
  String record;    /// 알람 시작 확인 및 날짜
  String sound;     /// 선택할 알람 파일 이름
  int count;        /// 수면기록 횟수

  UserInfoLocal({
    required this.name,
    // required this.volume,
    required this.record,
    required this.sound,
    required this.count
  });

  UserInfoLocal.fromJson(Map<String, Object?> json)
      : this(
      name: json['name']! as String,
      // volume: json['volume']! as double,
      record: json['record']! as String,
      sound: json['sound']! as String,
      count: json['count']! as int,
  );

  Map<String, Object?> toJson() {
    return {
      'name' : name,
      // 'volume' : volume,
      'record' : record,
      'sound' : sound,
      'count' : count
    };
  }

  @override
  String toString() {
    return '"UserInfoLocal" : { '
        '"name": $name, '
        // '"volume": $volume, '
        '"record": $record, '
        '"sound": $sound, '
        '"count": $count'
        '}';
  }
}