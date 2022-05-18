import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginButton extends StatelessWidget {
  final Buttons buttons;
  final Function onPressed;

  LoginButton({Key? key,
    required this.buttons,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: EdgeInsets.only( bottom: 10),
        child: SignInButton(
          buttons,
          onPressed: onPressed,
        )
    );
  }
}