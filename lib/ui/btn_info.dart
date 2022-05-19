import 'package:flutter/material.dart';
import 'package:d_button/d_button.dart';

class InfoButton extends StatelessWidget {
  final String btnName;
  final Function() onClick;

  const InfoButton({Key? key,
    required this.btnName,
    required this.onClick
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DButtonShadow(
        height: 60,
        width: MediaQuery.of(context).size.width,
        mainColor: Colors.black,
        shadowColor: Colors.grey,
        splashColor: Colors.grey,
        radius: 15,
       onClick: onClick,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 15),
            Text( btnName , style: const TextStyle( fontSize: 16, color: Colors.white ) ),
            const Expanded(child: SizedBox()),
            const Icon(Icons.chevron_right, color: Colors.white),
            const SizedBox(width: 15)
          ],
        )
    );
  }
}