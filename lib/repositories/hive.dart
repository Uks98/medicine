

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:medicine/models/medicineHistory.dart';

import '../models/medicine.dart';

class WHive{
  Future<void> initializeHive()async{
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<Medicine>(HiveBox.medicine);
    await Hive.openBox<MedicineHistory>(HiveBox.medicineHistory);
  }
}

class HiveBox{
  static const String medicine = "medicine";
  static const String medicineHistory = "medicineHistory";
}
