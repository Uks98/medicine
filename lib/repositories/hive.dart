

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/medicine.dart';

class WHive{
  Future<void> initializeHive()async{
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());

    await Hive.openBox<Medicine>(HiveBox.medicine);
  }
}

class HiveBox{
  static const String medicine = "medicine";
}
