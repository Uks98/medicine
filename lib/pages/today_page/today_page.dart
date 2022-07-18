import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine/components/constant.dart';
import 'package:medicine/components/page_route.dart';
import 'package:medicine/main.dart';
import 'package:medicine/models/medicine.dart';
import 'package:medicine/models/medicineHistory.dart';
import 'package:medicine/models/medicine_alarm.dart';
import 'package:medicine/pages/today_page/empty_widget.dart';
import 'package:medicine/pages/today_page/today_take_tile.dart';

import '../bottomSheet/time_setting-bottomsheet.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "오늘 복용할 약은?",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: regularSpace,
        ),
        Divider(
          height: 1,
          thickness: 2.0,
        ),
        Expanded(
            child: ValueListenableBuilder(
                valueListenable: medicineRepository.medicineBox.listenable(),
                builder: _builderMedicineListView))
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    //시간으로 출력해야해서 만든 리스트

    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return TodayEmpty();
    }
    for (final medicine in medicines) {
      for (final alarm in medicine.alarms) {
        medicineAlarms.add(
          MedicineAlarm(
              id: medicine.id,
              name: medicine.name,
              imagePath: medicine.imagePath,
              alarmTime: alarm,
              key: medicine.key),
        );
      }
    }
    return Column(
      children: [
        const Divider(
          height: 1,
          thickness: 1.0,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: regularSpace),
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                height: regularSpace,
              );
            },
            itemBuilder: (context, index) {
              return _buildListTile(medicineAlarm: medicineAlarms[index]);
            },
            itemCount: medicineAlarms.length,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1.0,
        ),
      ],
    );
  }

  Widget _buildListTile({required MedicineAlarm medicineAlarm}) {
    return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if (historyBox.values.isEmpty) {
          return BeforeTakeTime(medicineAlarm: medicineAlarm);
        }
        final todayTakeHistory = historyBox.values.singleWhere(
            (history) =>
                history.medicineId == medicineAlarm.id &&
                medicineAlarm.key == history.medicineKey &&
                history.alarmTime == medicineAlarm.alarmTime &&
                isToday(history.takeTime, DateTime.now()),
            orElse: () => MedicineHistory(
                medicineId: -1,
                alarmTime: "",
                takeTime: DateTime.now(),
                medicineKey: -1, name: '',imagePath: null));
        print(todayTakeHistory);
        if (todayTakeHistory.medicineId == -1 &&
            todayTakeHistory.alarmTime == "") {
          return BeforeTakeTime(medicineAlarm: medicineAlarm);
        }
        return AfterTakeTile(
          medicineAlarm: medicineAlarm,
          history: todayTakeHistory,
        );
      },
    );
  }
}

bool isToday(DateTime source, DateTime destination) {
  return source.year == destination.year &&
      source.month == destination.month &&
      source.day == destination.day;
}
