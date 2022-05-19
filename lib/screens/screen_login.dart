import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:sleeper/controllers/controller_login.dart';
import 'package:sleeper/ui/btn_login.dart';
import 'package:sleeper/utils/strings.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Stack(
            children: [
              Container(  // 밑 바탕 배경색
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
              ),
              Align(  // 배경 이미지 설정
                alignment: const Alignment(0 , -1),
                child: Column(
                    children: const [
                      SizedBox( height: 80 ),
                      Image(image: AssetImage(Word.PATH_IMAGE2)),  // 배경 이미지 경로
                    ]
                  )
              ),

              //////////// Login Button  ////////
              Align(
                alignment: const Alignment(0 , 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LoginButton(buttons: Buttons.Google, onPressed: (){ controller.loginGoogle(); } ),
                    // LoginButton(buttons: Buttons.FacebookNew, onPressed: (){ controller.loginFacebook(); } ),
                    LoginButton(buttons: Buttons.GitHub, onPressed: (){ controller.loginGithub(context); } ),
                    const SizedBox( height: 80 )
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}