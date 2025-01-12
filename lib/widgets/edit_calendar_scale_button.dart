import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/scale_factor_controller.dart';

class EditButton extends StatelessWidget {
  final scaleFactorController = Get.find<ScaleFactorController>();

  EditButton({super.key});
  @override
  Widget build(BuildContext context) {
    double scaleFactor = scaleFactorController.scaleFactor.value.toDouble();
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // Show Bottom Sheet with a slider
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Adjust Scale Factor',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Slider(
                        value: scaleFactor,
                        min: 1,
                        max: 25,
                        divisions: 24,
                        label: '${scaleFactor.round()}',
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
