import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scale_factor_controller.dart';
import '../controllers/theme_controller.dart';

class EditCalendarScaleButton extends StatelessWidget {
  final ScaleFactorController scaleFactorController =
      Get.find<ScaleFactorController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                double scaleFactor =
                    scaleFactorController.scaleFactor.value.toDouble();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Adjust Calendar Scale'),
                      Slider(
                        value: scaleFactor,
                        min: 1.0,
                        max: 20.0,
                        divisions: 19,
                        label: scaleFactor.toString(),
                        onChanged: (double value) {
                          setState(() {
                            scaleFactor = value;
                            scaleFactorController.setScaleFactor(value.toInt());
                          });
                        },
                        onChangeEnd: (double value) {
                          scaleFactorController
                              .setAndSaveScaleFactor(value.toInt());
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      tooltip: 'Change Calendar Scale',
    );
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Tooltip(
        message: 'Toggle Theme',
        child: Switch(
          value: themeController.isDarkMode.value,
          onChanged: (bool value) {
            themeController.toggleTheme();
          },
        ),
      );
    });
  }
}
