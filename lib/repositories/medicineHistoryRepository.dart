import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:medicine/models/medicineHistory.dart';
import '../models/medicine.dart';
import 'hive.dart';
import 'package:medicine/models/medicineHistory.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  //getter 접근 제어자 사용해서 _historyBox 접근
  Box<MedicineHistory> get historyBox {
    _historyBox ??= Hive.box<MedicineHistory>(HiveBox.medicineHistory);
    return _historyBox!;
  }

  void addHistory(MedicineHistory history) async {
    int key = await historyBox.add(history);

    log('[addMedicine] add (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);

    log('[deleteMedicine] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory history,
  }) async {
    //동일한 키 값일떄는 put은 업데이트를 수행한다
    await historyBox.put(key, history);

    log('[updateMedicine] update (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }


}