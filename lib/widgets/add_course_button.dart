import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../controllers/courses_controller.dart';

class AddCourseButton extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final String semesterPlanId;
  final coursesController = Get.find<CourseController>();
  final FocusNode _focusNode = FocusNode();

  AddCourseButton({required this.semesterPlanId});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _focusNode.requestFocus();
            });

            return AlertDialog(
              title: Text('Add Course'),
              content: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'course_name',
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'Course Name *',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          _formKey.currentState?.reset();
                          coursesController.addCourse(
                            _formKey.currentState?.value['course_name'],
                            semesterPlanId,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Add Course'),
    );
  }
}
