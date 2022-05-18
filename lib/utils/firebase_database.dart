import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:sleeper/models/alarm_info.dart';
import 'package:sleeper/models/alarm_record.dart';
import 'package:sleeper/models/user_info.dart';
import 'package:sleeper/utils/strings.dart';

class FirebaseDataBase {
  static const key = 'alarm';

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final User? userInfo = FirebaseAuth.instance.currentUser;
  Reference storageRef = FirebaseStorage.instance.ref();

  Image? image;
  List<AlarmInfo> alarmList = [];
  UserInfoLocal userInfoLocal = UserInfoLocal(name: Word.INIT_NAME, record: '', sound: Word.SOUND_VALUE[0], count: 0);

  /////////////////// Alarm //////////////////////////////////////////////////////////

  /// FireStore Alarm List 가져오기
  Future<List<AlarmInfo>> getAlarmList() async {
    CollectionReference reference = _database.collection('${userInfo?.email}');
    return reference.get().then((snapshot) {
      List<AlarmInfo> alarmList = [];
      List<QueryDocumentSnapshot> list = snapshot.docs;
      for (QueryDocumentSnapshot row in list) {
        Map<String, dynamic> mapData = row.data() as Map<String, dynamic>;
        AlarmInfo info = AlarmInfo.fromJson(mapData);
        info.document = row.id; // document ID 추가
        alarmList.add(info);
      }
      alarmList.sort((a, b) => a.index.compareTo(b.index));
      return alarmList;
    });
  }

  /// FireStore Alarm 등록하기
  Future<void> addAlarm(AlarmInfo info) async {
    CollectionReference reference = _database.collection('${userInfo?.email}');
    return reference
        .add({
      'index': info.index,
      'time': info.time,
      'isRun': info.isRun,
      'day' : info.day
    })
        .then((value) => print("Alarm Add"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// FireStore Alarm 수정하기
  Future<void> updateAlarm(AlarmInfo info) {
    CollectionReference reference = _database.collection('${userInfo?.email}');
    return reference
        .doc('${info.document}')
        .update({
          'index': info.index,
          'time': info.time,
          'isRun': info.isRun,
          'day': info.day
        })
        .then((value) => print("Alarm Update"))
        .catchError((error) => print("Failed to update Alarm: $error"));
  }

  /// FireStore Alarm 수정하기 , no Refresh
  Future<void> onlyUpdateAlarm(AlarmInfo info) {
    CollectionReference reference = _database.collection('${userInfo?.email}');
    return reference
        .doc('${info.document}')
        .update({
      'index': info.index,
      'time': info.time,
      'isRun': info.isRun,
      'day': info.day
    })
        .catchError((error) => print("Failed to update Alarm: $error"));
  }

  /// FireStore Alarm 삭제하기
  Future<void> deleteAlarm(int index) {
    CollectionReference reference = _database.collection('${userInfo?.email}');
    return reference
        .doc(alarmList[index].document)
        .delete()
        .then((value) => print("Alarm Delete"))
        .catchError((error) => print("Failed to delete Alarm: $error"));
  }

  /// FireStore Alarm Index Sort
  Future<void> sortIndexAlarm() async {
    for (int i = 0; i < alarmList.length; i++) {
      alarmList[i].index = i;
      if (i < alarmList.length-1) {
        onlyUpdateAlarm(alarmList[i]);
      } else {
        return updateAlarm(alarmList[i]);
      }
    }
  }


  /////////////////// Record //////////////////////////////////////////////////////////

  /// FireStore Record List 가져오기
  Future<List<AlarmRecord>> getRecordList() async {
    CollectionReference reference = _database.collection('${userInfo?.email}_record');
    return reference.get().then((snapshot) {
      List<AlarmRecord> recordList = [];
      List<QueryDocumentSnapshot> list = snapshot.docs;
      for (QueryDocumentSnapshot row in list) {
        Map<String, dynamic> mapData = row.data() as Map<String, dynamic>;
        AlarmRecord record = AlarmRecord.fromJson(mapData);
        recordList.add(record);
      }
      recordList.sort((a, b) => a.sDate.compareTo(b.sDate));

      return recordList;
    });
  }

  /// FireStore Record List 가져오기
  Future<AlarmRecord?> getRecordDate(String date) async {
    DocumentReference reference = _database.collection('${userInfo?.email}_record').doc(date);
    return reference.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        AlarmRecord record = AlarmRecord.fromJson(mapData);
        return record;
      } else {
        return null;
      }
    });
  }

  /// FireStore Record 등록하기
  Future<void> addRecord(String date, String time) async {
    CollectionReference reference = _database.collection('${userInfo?.email}_record');
    return reference.doc(date).set({  /// 당일 날짜로 Document Id 지정
      'sDate': date,
      'sTime': time,
    })
        .then((value) => print("Record Add"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// FireStore Record 수정하기
  Future<void> updateRecord(String docId, String date, String time) {
    CollectionReference reference = _database.collection('${userInfo?.email}_record');
    return reference.doc(docId).update({
      'eDate': date,
      'eTime': time,
    }).then((value) async {
      userInfoLocal.count++;
      await updateInfo(userInfoLocal);
      print("Record Update");
    }).catchError((error) => print("Failed to update Record: $error"));
  }


  /////////////////// Info //////////////////////////////////////////////////////////

  /// FireStore Alarm List 가져오기
  Future<UserInfoLocal> getInfo() async {
    DocumentReference reference = _database.collection('${userInfo?.email}_info').doc('info');
    return reference.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        return UserInfoLocal.fromJson(mapData);
      } else {
        addInfo();
        return UserInfoLocal(name: Word.INIT_NAME, record: '', sound: Word.SOUND_VALUE[0], count: 0);
      }
    });
  }

  /// FireStore Info 등록하기 init
  Future<void> addInfo() async {
    CollectionReference reference = _database.collection('${userInfo?.email}_info');
    return reference.doc('info').set({    // info 라는 documentID 로 저장.
          'name': Word.INIT_NAME,
          'record': '',
          'sound': Word.SOUND_VALUE[0],
          'count': 0,
        })
        .then((value) => print("Info Add"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// FireStore Info 등록하기 init
  Future<UserInfoLocal> addInfo2() async {
    UserInfoLocal info = UserInfoLocal(name: Word.INIT_NAME, record: '', sound: Word.SOUND_VALUE[0], count: 0);
    CollectionReference reference = _database.collection('${userInfo?.email}_info');
    return reference.doc('info').set(info).then((value) {
      return info;
    })
        .catchError((error) => print("Failed to add user: $error"));
  }

  /// FireStore Info 이름 수정하기
  Future<void> updateInfo(UserInfoLocal info) {
    CollectionReference reference = _database.collection('${userInfo?.email}_info');
    return reference.doc('info').update({
      'name': info.name,
      'record': info.record,
      'sound': info.sound,
      'count': info.count
    })
        .then((value) => print("Info Update"))
        .catchError((error) => print("Failed to update Alarm: $error"));
  }


  /// FireStorage File Upload
  Future<void> uploadFile(XFile file) async {
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path}
    );

    storageRef.child('photos').child('/${userInfo?.email}.jpg');
    UploadTask uploadTask = storageRef.putFile(File(file.path), metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print( 'Task state: ${snapshot.state}' );
      print( 'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %' );
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await uploadTask;
      image = Image.file(File(file.path));
      print('Upload complete.');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  /// FireStorage File Download
  Future<void> downloadFile() async {
    storageRef = storageRef.child('photos').child('/${userInfo?.email}.jpg');
    try {
      String url = await storageRef.getDownloadURL();
      image = Image.network(url);
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
    }
  }
}