


import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 1)
class Medicine extends HiveObject{
  Medicine(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.alarms});
  @HiveField(1)
  final int id;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String? imagePath;
  @HiveField(4)
  final List<String> alarms;

  @override
  String toString() {
    // TODO: implement toString
    return "id : $id name : $name path : $imagePath, alarm : $alarms";
  }
}
