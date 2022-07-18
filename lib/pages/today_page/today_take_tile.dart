import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine/pages/today_page/today_page.dart';

import '../../components/constant.dart';
import '../../components/page_route.dart';
import '../../main.dart';
import '../../models/medicineHistory.dart';
import '../../models/medicine_alarm.dart';
import '../bottomSheet/time_setting-bottomsheet.dart';
import 'image_detail_page.dart';

class BeforeTakeTime extends StatelessWidget {
  const BeforeTakeTime({Key? key, required this.medicineAlarm})
      : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          MedicineImageButton(imagePath: medicineAlarm.imagePath),
          const SizedBox(
            width: smallSpace,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTileBody(textStyle, context),
              ),
            ),
          ),
          //삭제 버튼
          _MoreButton(medicineAlarm: medicineAlarm)
        ],
      ),
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
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
            onTap: () {
              historyRepository.addHistory(MedicineHistory(
                  medicineId: medicineAlarm.id,
                  alarmTime: medicineAlarm.alarmTime,
                  takeTime: DateTime.now(), //바뀐시간
                  medicineKey: medicineAlarm.key,
                  imagePath: medicineAlarm.imagePath,
                  name: medicineAlarm.name));
            },
          ),
          Text(
            "|",
            style: textStyle,
          ),
          TileActionButton(title: '아까', onTap: () => _onPreviousTake(context)),
          Text(
            "먹었어요",
            style: textStyle,
          ),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeSettingBottomSheet(
          initialTime: medicineAlarm.alarmTime,
        );
      },
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) return;
      historyRepository.addHistory(MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime, //바뀐시간
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name));
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile(
      {Key? key, required this.medicineAlarm, required this.history})
      : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history; //바텀시트로 수정된 시간
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          Stack(
            children: [
              MedicineImageButton(imagePath: medicineAlarm.imagePath),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.withOpacity(0.8),
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            width: smallSpace,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTileBody(textStyle, context),
              ),
            ),
          ),
          //삭제 버튼
          _MoreButton(medicineAlarm: medicineAlarm)
        ],
      ),
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    final takeTime = DateFormat("HH:mm").format(history.takeTime);
    return [
      Text(
        "${medicineAlarm.alarmTime} → ${takeTimeStr}",
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
            title: '${takeTimeStr}분에',
            onTap: () => _onTap(context),
          ),
          Text(
            "먹었어요",
            style: textStyle,
          ),
        ],
      )
    ];
  }

  String get takeTimeStr => DateFormat("HH:mm").format(history.takeTime);

  void _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeSettingBottomSheet(
          initialTime: takeTimeStr,
          submitTitle: "선택",
          bottomWidget: TextButton(
            child: Text(
              "복약시간을 지우고 싶어요.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () {
              historyRepository.deleteHistory(history.key);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) return;
      historyRepository.updateHistory(
          key: history.key,
          history: MedicineHistory(
              medicineId: medicineAlarm.id,
              alarmTime: medicineAlarm.alarmTime,
              takeTime: takeDateTime,
              //바뀐시간
              medicineKey: medicineAlarm.key,
              imagePath: medicineAlarm.imagePath,
              name: medicineAlarm.name));
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: () {
          medicineRepository.deleteMedicine(medicineAlarm.key);
          print(medicineAlarm.key);
        },
        child: Icon(CupertinoIcons.ellipsis_vertical));
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.pop(context,
                  FadePageRoute(page: ImageDetailPage(imagePath: imagePath!)));
            },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
      ),
    );
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
