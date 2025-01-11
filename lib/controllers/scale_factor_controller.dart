import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ScaleFactorController {
  final storage = Hive.box('storage');

  RxInt scaleFactor = 8.obs;

  ScaleFactorController() {
    if (storage.get('scaleFactor') == null) {
      storage.put('scaleFactor', 8);
    }
    scaleFactor.value = storage.get('scaleFactor') as int;
  }

  void _save() {
    storage.put('scaleFactor', scaleFactor.value);
  }

  void setScaleFactor(int value) {
    scaleFactor.value = value;
  }

  void setAndSaveScaleFactor(int value) {
    setScaleFactor(value);
    _save();
  }
}
