import 'dart:developer';
import 'package:hive/hive.dart';
import '../models/medicine.dart';
import 'hive.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  //getter 접근 제어자 사용해서 _medicineBox 접근
  Box<Medicine> get medicineBox {
    _medicineBox ??= Hive.box<Medicine>(HiveBox.medicine);
    return _medicineBox!;
  }

  void addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('[deleteMedicineß] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({
    required int key,
    required Medicine medicine,
  }) async {
    //동일한 키 값일떄는 put은 업데이트를 수행한다
    await medicineBox.put(key, medicine);

    log('[updateMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {

    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id; //빈 리스트에는 last 값이 없기때문에 상항연산자 처리
    return lastId + 1;
  }

}