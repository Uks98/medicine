


import 'package:hive/hive.dart';

part 'medicineHistory.g.dart';

@HiveType(typeId: 2)
class MedicineHistory extends HiveObject{
  MedicineHistory(
      {
         required this.medicineId,
         required this.alarmTime,
         required this.takeTime, //오늘 복약했는지,오늘 시간과 동일한지
         required this.medicineKey,
         required this.name,
         required this.imagePath,
      });
  @HiveField(0)
  final int medicineId;
  @HiveField(1)
  final String alarmTime;
  @HiveField(2)
  final DateTime takeTime;
  @HiveField(3,defaultValue: -1)
  final int medicineKey;
  @HiveField(4,defaultValue: "")
  final String name;
  @HiveField(5)
  final String? imagePath;

  @override
  String toString() {
    // TODO: implement toString
    return "medicineId : $medicineId alarmTime : $alarmTime takeTime : $takeTime medicineKey : $medicineKey, name : $name imagePath : $imagePath";
  }
}
