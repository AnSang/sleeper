import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_info.dart';
import '../utils/firebase_database.dart';
import 'controller_main.dart';

class InfoController extends GetxController {
  int selBtnNum = -1;
  FirebaseDataBase dataBase = Get.find<MainController>().dataBase;
  TextEditingController editController = TextEditingController();

  late UserInfoLocal info;

  /// Bottom Sheet Data
  int selectSound = 0;

  @override
  void onInit() {
    initInfo();
    super.onInit();
  }

  /// init NickName, info
  void initInfo() {
    info = UserInfoLocal(name: dataBase.userInfoLocal.name,
        record: dataBase.userInfoLocal.record,
        sound: dataBase.userInfoLocal.sound,
        count: dataBase.userInfoLocal.count);
    editController.clear();
    update();
  }

  /// 사용자 정보 변경 어떤 버튼 눌렀는지 check
  void setSelBtnNum(int num) {
    selBtnNum = num;
    update();
  }

  /// 사용자 닉네임 설정
  void setUserName() {
    info.name = editController.text;
  }

  /// 사용자 알람 파일명 설정
  void setSoundName(String fileName) {
    info.sound = fileName;
  }

  /// Info 설정 값 FireStore에 저장
  void updateInfo() async {
    await dataBase.updateInfo(UserInfoLocal(name: info.name, record: info.record, sound: info.sound, count: info.count));
    dataBase.userInfoLocal = info;
    update();
  }

  /// 프로필 사진 업로드
  void upLoadPhoto(XFile file) async {
   await dataBase.uploadFile(file);
   update();
  }

  /// 프로필 사진 다운로드
  void downloadPhoto() async {
    await dataBase.downloadFile();
    update();
  }
}