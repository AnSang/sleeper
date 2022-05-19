import 'package:get/get.dart';

class ScreenController extends GetxController {
  static const key = 'LoginInfo';

  var autoLogin = false;
  var showScreenIndex = 0;

  void setScreen(int index) {
    showScreenIndex = index;
    update();
  }
}