import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../controllers/semester_plan_controller.dart';

class AddSemesterPlanButton extends StatelessWidget {
  AddSemesterPlanButton({Key? key}) : super(key: key);

  static final _formKey = GlobalKey<FormBuilderState>();
  final SemesterPlanController planController =
      Get.find<SemesterPlanController>();

  @override
  Widget build(BuildContext context) {
    final SemesterPlanFormController controller =
        Get.put(SemesterPlanFormController());

    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Create Semester Plan'),
              content: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Select Semester:'),
                      const SizedBox(height: 8.0),
                      Obx(() => SegmentedButton<int>(
                            segments: const <ButtonSegment<int>>[
                              ButtonSegment(
                                value: 0,
                                label: Text('Spring'),
                              ),
                              ButtonSegment(
                                value: 1,
                                label: Text('Autumn'),
                              ),
                            ],
                            selected: {controller.isSelected.indexOf(true)},
                            onSelectionChanged: (Set<int> newSelection) {
                              if (newSelection.isNotEmpty) {
                                controller.toggleSelection(newSelection.first);
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final title = _formKey.currentState?.value['title'];
                      final semester = controller.isSelected.indexOf(true);
                      final semesterName = semester == 0 ? 'Spring' : 'Autumn';
                      planController.addPlan(title, semesterName);

                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                          'Error', 'Please fill all fields correctly.');
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
