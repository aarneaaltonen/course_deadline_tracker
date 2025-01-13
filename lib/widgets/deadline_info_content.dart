import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../controllers/deadline_controller.dart';
import '../models/models.dart';

class DeadlineInfoContent extends StatelessWidget {
  final Deadline deadline;
  const DeadlineInfoContent({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final DeadlineController controller = Get.find<DeadlineController>();
    final _formKey = GlobalKey<FormBuilderState>();
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy ');
    final DateFormat timeFormat = DateFormat('HH:mm:ss');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateFormat.format(deadline.dueDate),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              timeFormat.format(deadline.dueDate),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'description',
                    initialValue: deadline.description,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      final updatedDeadline = Deadline(
                        id: deadline.id,
                        courseId: deadline.courseId,
                        description: value,
                        dueDate: deadline.dueDate,
                        isCompleted:
                            _formKey.currentState?.fields['completed']?.value ??
                                false,
                      );
                      controller.updateDeadline(updatedDeadline);
                    },
                  ),
                  SizedBox(height: 16),
                  FormBuilderCheckbox(
                    name: 'completed',
                    initialValue: deadline.isCompleted,
                    title: Text('Completed'),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final updatedDeadline = Deadline(
                        id: deadline.id,
                        courseId: deadline.courseId,
                        description: _formKey
                                .currentState?.fields['description']?.value ??
                            '',
                        dueDate: deadline.dueDate,
                        isCompleted: value ?? false,
                      );
                      controller.updateDeadline(updatedDeadline);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        tooltip: 'Delete deadline',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete deadline'),
                                  content: Text(
                                      'Are you sure you want to delete this deadline?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        controller.deleteDeadline(deadline.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
