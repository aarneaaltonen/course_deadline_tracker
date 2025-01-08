import 'package:flutter/material.dart';

class AddDeadlineButton extends StatelessWidget {
  final String courseId;

  AddDeadlineButton({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add, size: 20.0),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final _formKey = GlobalKey<FormState>();
            final _descriptionController = TextEditingController();
            DateTime? _selectedDate;
            TimeOfDay? _selectedTime;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Add Deadline'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(labelText: 'Description'),
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
                            _selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            setState(() {});
                          },
                          child: Text('Select Date'),
                        ),
                        if (_selectedDate != null)
                          Text(
                              'Selected date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            _selectedTime = await showTimePicker(
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
                        if (_selectedTime != null)
                          Text(
                              'Selected time: ${_selectedTime!.format(context)}'),
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
                        if (_formKey.currentState!.validate()) {
                          // Save the deadline information
                          print('Selected date: $_selectedDate');
                          print('Selected time: $_selectedTime');
                          Navigator.of(context).pop();
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
