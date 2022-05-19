import 'package:d_button/d_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sleeper/controllers/controller_record.dart';
import 'package:time_chart/time_chart.dart';

import '../utils/strings.dart';

class ScreenRecord extends StatelessWidget {
  const ScreenRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordController>(
      init: RecordController(),
      builder: (controller) {
        if (!controller.check) {
          return const SpinKitFadingCircle( color: Colors.white, size: 60 );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('수면 기록 차트',
                    style: TextStyle( fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold )),
                const SizedBox(height: 30),
                GetBuilder<RecordController>(
                    builder: (controller) {
                      return TimeChart(
                        data: controller.showItems,
                        chartType: ChartType.time,
                        viewMode: ViewMode.monthly,
                        tooltipStart: Word.SLEEP_START,
                        tooltipEnd: Word.SLEEP_END,
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        barColor: Colors.deepPurple,
                      );
                    }
                ),
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
                        onClick: controller.btnStart ? (){ controller.startRecord(); } : null,
                        child: const Text('수면 시작', style: TextStyle(fontSize: 16, color: Colors.white) )
                    ),
                    DButtonShadow(
                        height: 60,
                        width: 150,
                        mainColor: Colors.black,
                        shadowColor: Colors.grey,
                        disableColor: Colors.black87,
                        radius: 15,
                        onClick: controller.btnEnd ? (){
                          controller.endRecord();
                        } : null,
                        child: const Text(Word.SLEEP_END, style: TextStyle(fontSize: 16, color: Colors.white) ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      }
    );
  }
}