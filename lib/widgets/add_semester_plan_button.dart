import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../controllers/semester_plan_controller.dart';

class AddSemesterPlanButton extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final planController = Get.find<SemesterPlanController>();

  @override
  Widget build(BuildContext context) {
    //dont think wee need to inverse control here, controller used only here
    final SemesterPlanFormController controller =
        Get.put(SemesterPlanFormController());

    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create Semester Plan'),
              content: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 16.0),
                      Text('Select Semester:'),
                      SizedBox(height: 8.0),
                      FormBuilderField(
                        name: 'semester',
                        initialValue: controller.isSelected.indexOf(true),
                        builder: (FormFieldState<int> field) {
                          return Obx(() => ToggleButtons(
                                isSelected: controller.isSelected,
                                onPressed: (int index) {
                                  controller.toggleSelection(index);
                                  field.didChange(index);
                                },
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text('Spring'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text('Autumn'),
                                  ),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Create'),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // Handle save action
                      planController.addPlan(
                        _formKey.currentState?.fields['title']?.value,
                        controller.isSelected.indexOf(true) == 0
                            ? 'Spring'
                            : 'Autumn',
                      );
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      tooltip: 'Create Semester Plan',
      child: const Icon(Icons.add),
    );
  }
}
