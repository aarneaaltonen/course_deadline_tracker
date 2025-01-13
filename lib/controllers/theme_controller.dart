import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeController extends GetxController {
  final storage = Hive.box('storage');

  RxBool isDarkMode = false.obs;

  ThemeController() {
    if (storage.get('isDarkMode') == null) {
      storage.put('isDarkMode', false);
    }
    isDarkMode.value = storage.get('isDarkMode') as bool;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storage.put('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
