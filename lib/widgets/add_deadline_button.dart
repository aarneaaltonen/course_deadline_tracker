import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/deadline_controller.dart';

class AddDeadlineHandler {
  final DeadlineController deadlineController = Get.find<DeadlineController>();

  void handleAddDeadline(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        final descriptionController = TextEditingController();
        DateTime? selectedDate;
        TimeOfDay? selectedTime;
        String? dateError;
        final FocusNode focusNode = FocusNode();

        // Request focus after the dialog is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Deadline'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        setState(() {
                          dateError = null; // Clear any previous error
                        });
                      },
                      child: Text('Select Date *'),
                    ),
                    if (selectedDate != null)
                      Text(
                          'Selected date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                    if (dateError != null)
                      Text(
                        dateError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Text('Select Time'),
                    ),
                    if (selectedTime != null)
                      Text('Selected time: ${selectedTime!.format(context)}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (selectedDate == null) {
                        setState(() {
                          dateError = 'Please select a date';
                        });
                      } else {
                        // Save the deadline information
                        deadlineController.addDeadline(
                          courseId,
                          selectedDate!,
                          selectedTime,
                          descriptionController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AddDeadlineButtonFromCourseCard extends StatelessWidget {
  final String courseId;
  final AddDeadlineHandler addDeadlineHandler = AddDeadlineHandler();

  AddDeadlineButtonFromCourseCard({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Add Deadline",
      icon: Icon(
        Icons.add,
        size: 24.0, // Slightly larger for emphasis
        color: Colors.white, // White color for better visibility
      ),
      onPressed: () => addDeadlineHandler.handleAddDeadline(context, courseId),
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size(40.0, 90.0)),
        backgroundColor:
            WidgetStateProperty.all(const Color.fromARGB(0, 68, 137, 255)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        overlayColor:
            WidgetStateProperty.all(const Color.fromARGB(91, 255, 255, 255)),
      ),
    );
  }
}

class AddDeadlineButtonFromModal extends StatelessWidget {
  //seperating these allows to pop out of modal here (and have different styles)
  final String courseId;
  final AddDeadlineHandler addDeadlineHandler = AddDeadlineHandler();

  AddDeadlineButtonFromModal({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: "Add Deadline",
      icon: Icon(
        Icons.add,
        size: 30.0,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        addDeadlineHandler.handleAddDeadline(context, courseId);
      },
    );
  }
}
