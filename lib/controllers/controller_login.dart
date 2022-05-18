import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sleeper/screens/screen_main.dart';

import '../utils/firebase_auth.dart';

class LoginController extends GetxController {
  static const key = 'LoginInfo';

  bool autoLogin = false;
  bool chkTerms = false;
  int showScreenIndex = 0;

  FirebaseAuthentication auth = FirebaseAuthentication();

  void setScreen(int index) {
    showScreenIndex = index;
    update();
  }

  void loginGoogle() {
    auth.loginWithGoogle().then((value) {
      if (value == null) {
        Fluttertoast.showToast(msg: 'Google Login Fail');
      } else {
        Fluttertoast.showToast(msg: 'Google Login Success');
        Get.off(() => const ScreenMain());
      }
    });
  }

  void loginFacebook() {
    auth.signInWithFacebook().then((value) {
      if (value == null) {
        Fluttertoast.showToast(msg: 'FaceBook Login Fail');
      } else {
        Fluttertoast.showToast(msg: 'FaceBook Login Success');
        Get.off(() => const ScreenMain());
      }
    });
  }

  void loginGithub(BuildContext context) {
    auth.signInWithGitHub(context).then((value) {
      if (value == null) {
        Fluttertoast.showToast(msg: 'Github Login Fail');
      } else {
        Fluttertoast.showToast(msg: 'Github Login Success');
        Get.off(() => const ScreenMain());
      }
    });
  }

  /// 개인정보약관 체크
  void setTerms(bool? value) {
    value == null ? chkTerms = false : chkTerms = value;
    update();
  }

  /*void loginKakao() {
    auth.signInWithKaKao().then((value) {
      if (value == null) {
        Fluttertoast.showToast(msg: 'KaKao Login Fail');
      } else {
        Fluttertoast.showToast(msg: 'KaKao Login Success');
        Get.off(() => ScreenMain());
      }
    });
  }*/
}