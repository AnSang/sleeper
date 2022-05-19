import 'package:d_button/d_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sleeper/controllers/controller_info.dart';
import 'package:sleeper/main.dart';
import 'package:sleeper/screens/screen_terms.dart';
import 'package:sleeper/ui/btn_info.dart';
import 'package:sleeper/utils/strings.dart';

class ScreenInfo extends StatelessWidget {
  const ScreenInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InfoController>(
        init: InfoController(),
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox( // User Profile
                      child: Stack(
                        alignment: const Alignment(0, 0),
                        children: [
                          DButtonShadow(
                              radius: 30,
                              height: 120,
                              width: 120,
                              mainColor: Colors.white,
                              splashColor: Colors.grey,
                              shadowColor: Colors.grey,
                              onClick: () => { onImageButtonPressed(context, controller) },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: controller.dataBase.image ?? const Image(image: AssetImage(Word.PATH_IMAGE3)),
                              )
                          ),
                          Align(
                              alignment: const Alignment(0, 0),
                              child: Container(
                                padding: const EdgeInsets.only(left: 90, top: 90),
                                child: DButtonCircle(
                                  disableColor: Colors.white,
                                  shadowColor: Colors.grey,
                                  diameter: 40,
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.black, size: 20),
                                  onClick: () => { onImageButtonPressed(context, controller) },
                                ),
                              )
                          )
                        ],
                      )),
                  const SizedBox(height: 20),
                  Text(
                    '${controller.dataBase.userInfoLocal.name} 님의 총 수면기록 ${controller.dataBase.userInfoLocal.count}회',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InfoButton(btnName: Word.INFO_BTN_CHANGE, onClick: () { clickButton1(context); } ),
                        const SizedBox(height: 20),
                        InfoButton(btnName: Word.INFO_BTN_SOUND, onClick: () { clickButton2(context); } ),
                        const SizedBox(height: 20),
                        InfoButton(btnName: Word.INFO_BTN_REC_DEL,
                          onClick: () {
                          /// Record 정보가 없으면 삭제할일이 없으니 비활성화
                          controller.dataBase.userInfoLocal.record.isEmpty ?
                          Fluttertoast.showToast(msg: Word.DELETE_RECORD_X, backgroundColor: Colors.white, textColor: Colors.black)
                              : deleteRecord(context, controller);
                          }
                        ),
                        const SizedBox(height: 20),
                        InfoButton(btnName: Word.INFO_BTN_TERMS, onClick: () { Get.to(const InfoTerms()); } ),
                        const SizedBox(height: 20),
                        InfoButton(btnName: Word.INFO_BTN_LOGOUT, onClick: () { logOutDialog(context); }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
     );
  }

  void clickButton1(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical( top: Radius.circular(24) ) ),
        builder: (context) {
          return GetBuilder<InfoController>(
            builder: (controller) {
              return KeyboardVisibilityBuilder(
                  builder: (BuildContext context , bool isKeyboardVisible) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          infoModify(controller),
                          const SizedBox( height: 30 ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DButtonShadow(
                                  height: 60,
                                  width: 150,
                                  mainColor: Colors.black,
                                  shadowColor: Colors.grey,
                                  disableColor: Colors.black87,
                                  radius: 15,
                                  child: const Text(Word.CANCEL, style: TextStyle(fontSize: 16, color: Colors.white) ),
                                  onClick: (){
                                    Navigator.pop(context);
                                  },
                                ),

                                DButtonShadow(
                                    height: 60,
                                    width: 150,
                                    mainColor: Colors.black,
                                    shadowColor: Colors.grey,
                                    disableColor: Colors.black87,
                                    radius: 15,
                                    child: const Text(Word.CONFIRM, style: TextStyle(fontSize: 16, color: Colors.white) ),
                                    onClick: (){
                                      controller.setUserName();
                                      controller.updateInfo();
                                      Navigator.pop(context);
                                    }
                                )
                              ]
                          ),
                          const SizedBox( height: 30 ),

                          if (isKeyboardVisible)
                            SizedBox( height: MediaQuery.of(context).size.height / 3)
                        ]
                    );
                  }
              );
            },
          );
        }
    );
  }

  void clickButton2(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical( top: Radius.circular(24) ) ),
        builder: (context) {
          return GetBuilder<InfoController>(
            builder: (controller) {
              return KeyboardVisibilityBuilder(
                  builder: (BuildContext context , bool isKeyboardVisible) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          soundControll(context, controller),
                          const SizedBox( height: 30 ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DButtonShadow(
                                  height: 60,
                                  width: 150,
                                  mainColor: Colors.black,
                                  shadowColor: Colors.grey,
                                  disableColor: Colors.black87,
                                  radius: 15,
                                  child: const Text(Word.CANCEL, style: TextStyle(fontSize: 16, color: Colors.white) ),
                                  onClick: (){
                                    Navigator.pop(context);
                                  },
                                ),

                                DButtonShadow(
                                    height: 60,
                                    width: 150,
                                    mainColor: Colors.black,
                                    shadowColor: Colors.grey,
                                    disableColor: Colors.black87,
                                    radius: 15,
                                    child: const Text(Word.CONFIRM, style: TextStyle(fontSize: 16, color: Colors.white) ),
                                    onClick: (){
                                      controller.setSoundName(Word.SOUND_VALUE[controller.selectSound]);
                                      controller.updateInfo();
                                      Navigator.pop(context);
                                    }
                                )
                              ]
                          ),
                          const SizedBox( height: 30 ),

                          if (isKeyboardVisible)
                            SizedBox( height: MediaQuery.of(context).size.height / 3)
                        ]
                    );
                  }
              );
            },
          );
        }
    );
  }

  Widget infoModify(InfoController controller) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: controller.editController,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        cursorColor: Colors.black,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: Word.NICKNAME,
          hintText: Word.INPUT_NICKNAME,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          suffixIcon: GestureDetector(
            child: const Icon(
              Icons.cancel,
              color: Colors.blueAccent,
              size: 20,
            ),
            onTap: () => controller.editController.clear(),
          ),
        ),
      ),
    );
  }

  Widget soundControll(BuildContext context, InfoController controller) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric( horizontal: 40, vertical: 40 ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: ListWheelScrollView.useDelegate(
        itemExtent: 30,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.3,
        useMagnifier: true,
        magnification: 1.5,
        onSelectedItemChanged: (value) { controller.selectSound = value; },
        childDelegate: ListWheelChildBuilderDelegate(
            childCount: Word.SOUND_NAME.length,
            builder: (BuildContext context, int index) {
              if (index < 0 || index > Word.SOUND_NAME.length) {
                return null;
              }
              return Text(Word.SOUND_NAME[index], style: const TextStyle(color: Colors.black, fontSize: 20) );
            }
        ),
      ),
    );
  }

  void deleteRecord(BuildContext context, InfoController controller) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
            content: const Text(Word.DELETE_RECORD_O),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(Word.CANCEL)),
              TextButton(
                  onPressed: () {
                    controller.dataBase.userInfoLocal.record = '';
                    controller.dataBase.updateInfo(controller.dataBase.userInfoLocal);
                    controller.update();
                    Navigator.pop(context);
                  },
                  child: const Text(Word.CONFIRM))
            ],
          );
        }
    );
  }

  void logOutDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
            content: const Text(Word.LOGOUT),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(Word.CANCEL)),
              TextButton(
                  onPressed: () {
                    FlutterBackgroundService().invoke('stop');
                    FirebaseAuth.instance.signOut();
                    Get.off(const Authentication());
                  },
                  child: const Text(Word.CONFIRM))
            ],
          );
        }
    );
  }
}

Future<void> onImageButtonPressed(BuildContext context, InfoController controller) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(Word.UPLOAD_PICTURE),
              actions: <Widget>[
                TextButton(
                  child: const Text(Word.CANCEL),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text(Word.CONFIRM),
                    onPressed: () {
                      controller.upLoadPhoto(image);
                      Navigator.of(context).pop();
                    }),
              ],
            );
          }
      );
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Pick image error: $e');
  }
}
