import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine/components/colors.dart';
import 'package:medicine/components/constant.dart';
import 'package:medicine/components/widgets.dart';
import 'package:medicine/main.dart';
import 'package:medicine/models/medicine.dart';
import 'package:medicine/pages/add/add_medicine.dart';
import 'package:medicine/repositories/medicine.dart';
import 'package:medicine/services/file_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/add_medicine_service.dart';
import '../../services/notification.dart';
import 'add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);

  final File? medicineImage;
  final String medicineName;
  final service = AdMedicineService();
  final _notification = DoryNotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            "매일 복약 잊지 말아요!",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Expanded(
              child: AnimatedBuilder(
                  animation: service,
                  //notifyListeners
                  builder: (context, _) {
                    return ListView(
                      children: alarmWidgets,
                      //const [
                      //   AlarmBox(),
                      //   AlarmBox(),
                      //   AlarmBox(),
                      //   AlarmBox(),
                      //   AddAlarmButton(),
                      // ],
                    );
                  }))
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          bool result = false;
          for (var alarm in service.alarms) {
            result = await _notification.addNotifcication(
                alarmTimeStr: alarm,
                title: '$alarm 약 먹을 시간이에요~',
                body: "$medicineName 복약했나요?",
                medicineId: medicineRepository.newId);
          }
          if (!result) {
            //1. 알람설정 여부
            return showPermissionDenied(context, permission: "알람");
          }
          String? imageFilePath;
          if (medicineImage != null) {
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }
          final medicine = Medicine(
              id: medicineRepository.newId,
              name: medicineName,
              imagePath: imageFilePath,
              alarms: service.alarms.toList());
          //2. 이미지 저장
          medicineRepository.addMedicine(medicine);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      service.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        ),
      ),
    );

    /// alarms 을 여러 객채로 쪼개서 AlrarmBox로 만들어준다.
    children.add(AddAlarmButton(
      service: service,
    ));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  AlarmBox({
    Key? key,
    required this.time,
    required this.service,
  }) : super(key: key);
  final String time;
  final AdMedicineService service;
  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  service.removeAlarm(time);
                },
                icon: const Icon(CupertinoIcons.minus_circle))),
        Expanded(
            flex: 5,
            child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        final initTime = DateFormat("HH:mm").parse(time);
                        return BottomSheetBody(children: [
                          SizedBox(
                            child: CupertinoDatePicker(
                              onDateTimeChanged: (dateTime) {
                                _setDateTime = dateTime;
                              },
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: initTime,
                            ),
                            height: 200,
                          ),
                          const SizedBox(
                            height: regularSpace,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        onPrimary: DoryColors.primaryColor),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("취소"),
                                  ),
                                  height: 50,
                                ),
                              ),
                              const SizedBox(width: smallSpace),
                              Expanded(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    onPressed: () {
                                      service.setAlarm(
                                          prevTime: time,
                                          setTime: _setDateTime ?? initTime);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("선택"),
                                  ),
                                  height: 50,
                                ),
                              ),
                            ],
                          )
                        ]);
                      });
                },
                child: Text(time)))
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  AddAlarmButton({Key? key, required this.service}) : super(key: key);
  final AdMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          textStyle: Theme.of(context).textTheme.subtitle2),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.add_circled_solid)),
          Expanded(flex: 5, child: Center(child: Text("복용 시간 추가")))
        ],
      ),
    );
  }
}
