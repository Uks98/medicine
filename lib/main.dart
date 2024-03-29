import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:medicine/components/themes.dart';
import 'package:medicine/pages/home_page.dart';
import 'package:medicine/repositories/hive.dart';
import 'package:medicine/repositories/medicine.dart';
import 'package:medicine/repositories/medicineHistoryRepository.dart';
import 'package:medicine/services/notification.dart';
import 'package:intl/date_symbol_data_local.dart';

final notification = DoryNotificationService();
final hive = WHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

    notification.initializeTimeZone();
    await notification.initializeNotification();

  await hive.initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context,child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor:1.0 ), child: child!),
      title: 'Flutter Demo',
      theme: DoryThemes.lightTheme,
      home: HomePage(),
    );
  }
}
