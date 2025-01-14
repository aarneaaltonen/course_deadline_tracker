import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StandardSideSheetController extends GetxController {
  final storage = Hive.box('storage');

  RxBool isOpen = false.obs;

  StandardSideSheetController() {
    if (storage.get('isOpen') == null) {
      storage.put('isOpen', false);
    }
    isOpen.value = storage.get('isOpen') as bool;
  }

  void toggleSideSheet() {
    isOpen.value = !isOpen.value;
    storage.put('isOpen', isOpen.value);
  }
}
