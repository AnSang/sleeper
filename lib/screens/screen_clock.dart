import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleeper/controllers/controller_clock.dart';

class ScreenClock extends StatelessWidget {
  const ScreenClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockController>(
      init: ClockController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.formattedTime,
                  style: const TextStyle(color: Colors.white, fontSize: 50),
                ),
                Text(
                  controller.formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),

                const SizedBox( height: 40 ),

                SizedBox(
                  width: 300,
                  height: 300,
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: CustomPaint(
                      painter: ClockPainter(),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'UTC${controller.offsetSign}${controller.timezoneString}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ]
                )
              ]
            ),
          ),
        );
      }
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint() ..color = const Color(0xFF404040);

    var outlineBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    var centerFillBrush = Paint()
      ..color = const Color(0xFFEAECFF);

    var secHandBrush = Paint()
      ..color = Colors.orange.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var minHandBrush = Paint()
      ..shader = const RadialGradient(colors: [Color(0xFF748EF6), Color(0xFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = Colors.orange.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    var hourHandBrush = Paint()
      ..shader = const RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    var dashBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius - 20, fillBrush);
    canvas.drawCircle(center, radius - 20, outlineBrush);

    var hourHandX = centerX + 60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX + 60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + 80 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 12, centerFillBrush);

    var outerCircleRadius = radius - 20;
    var innerCircleRadius = radius - 40;
    for (double i = 0; i < 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}