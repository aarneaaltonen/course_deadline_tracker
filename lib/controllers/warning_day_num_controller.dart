import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class WarningDayNumController extends GetxController {
  final storage = Hive.box('storage');

  RxInt warningDayNum = 4.obs;

  WarningDayNumController() {
    if (storage.get('warningDayNum') == null) {
      storage.put('warningDayNum', 5);
    }
    warningDayNum.value = storage.get('warningDayNum') as int;
  }

  void _save() {
    storage.put('warningDayNum', warningDayNum.value);
  }

  void setWarningDayNum(int value) {
    warningDayNum.value = value;
  }

  void setAndSaveWarningDayNum(int value) {
    setWarningDayNum(value);
    _save();
  }
}
