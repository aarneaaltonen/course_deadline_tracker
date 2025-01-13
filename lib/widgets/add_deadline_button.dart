import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/deadline_controller.dart';

class AddDeadlineButton extends StatelessWidget {
  final String courseId;
  final DeadlineController deadlineController = Get.find<DeadlineController>();
  final FocusNode _focusNode = FocusNode();

  AddDeadlineButton({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Add Deadline",
      icon: Icon(Icons.add, size: 20.0, color: Colors.black),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final formKey = GlobalKey<FormState>();
            final descriptionController = TextEditingController();
            DateTime? selectedDate;
            TimeOfDay? selectedTime;
            String? dateError;

            // Request focus after the dialog is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _focusNode.requestFocus();
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
                          focusNode: _focusNode, // Assign the focus node here
                          decoration: InputDecoration(
                            labelText: 'Description',
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
                          child: Text('Select Date'),
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
                          Text(
                              'Selected time: ${selectedTime!.format(context)}'),
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
      },
    );
  }
}
