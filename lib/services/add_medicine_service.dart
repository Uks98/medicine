import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AdMedicineService with ChangeNotifier{
  final _alarms = <String>{"08:00", "13:00", "15:00"};

  Set<String>get alarms =>_alarms;
  void addNowAlarm(){
    final _now = DateTime.now(); //현재시간으로 추가
    final nowTime = DateFormat("HH:mm").format(_now);

    _alarms.add(nowTime);
    notifyListeners(); ///setstate랑 같은 함수
  }

  void removeAlarm(String alarmTime){
    _alarms.remove(alarmTime);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}){
    _alarms.remove(prevTime);
    final setTimeStr = DateFormat("HH:mm").format(setTime); //시간 추가
    _alarms.add(setTimeStr);
    notifyListeners();
  }
}