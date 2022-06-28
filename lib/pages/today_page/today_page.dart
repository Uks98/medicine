import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine/components/constant.dart';
import 'package:medicine/components/page_route.dart';
import 'package:medicine/main.dart';
import 'package:medicine/models/medicine.dart';
import 'package:medicine/models/medicine_alarm.dart';
import 'package:medicine/pages/today_page/empty_widget.dart';

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

    if(medicines.isEmpty){
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
              key: medicine.key
          ),
        );
      }
    }

    return Column(
      children: [
        const Divider(height: 1,thickness: 1.0,),
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
              return MedicineListTile(medicineAlarm: medicineAlarms[index]);
            },
            itemCount: medicineAlarms.length,
          ),
        ),
        const Divider(height: 1,thickness: 1.0,),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key, required this.medicineAlarm
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: medicineAlarm.imagePath == null ? null : () {
                Navigator.pop(context,FadePageRoute(page: ImageDetailPage(medicineAlarm: medicineAlarm)));
              },
              child: CircleAvatar(
                radius: 40,
                foregroundImage:medicineAlarm.imagePath == null? null : FileImage(File(medicineAlarm.imagePath!)),
              )),
          SizedBox(
            width: smallSpace,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${medicineAlarm.alarmTime}",
                    style: textStyle,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${medicineAlarm.name}",
                        style: textStyle,
                      ),
                      TileActionButton(
                        title: '지금',
                        onTap: () {},
                      ),
                      Text(
                        "|",
                        style: textStyle,
                      ),
                      TileActionButton(
                        title: '아까',
                        onTap: () {
                         showModalBottomSheet(context: context, builder: (context){
                           return TimeSettingBottomSheet(
                           initialTime:medicineAlarm.alarmTime,
                         );},).then((value){
                           print(value);
                         });
                        },
                      ),
                      Text(
                        "먹었어요",
                        style: textStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          //삭제 버튼
          CupertinoButton(
              onPressed: () {
                medicineRepository.deleteMedicine(medicineAlarm.key);
                print(medicineAlarm.key);
              }, child: Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: CloseButton(),),
      body: Center(
      child: Image.file(File(medicineAlarm.imagePath!)),
    ),);
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    this.textStyle,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final TextStyle? textStyle;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.bold);
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$title", style: buttonTextStyle),
        ));
  }
}
