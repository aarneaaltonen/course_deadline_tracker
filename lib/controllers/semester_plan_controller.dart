import 'package:aalto_course_tracker/models/models.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SemesterPlanController {
  final plans = <SemesterPlan>[].obs; //todo create plan model

  void addPlan(String title, String semester) {
    final uuid = Uuid();
    final id = uuid.v4();
    final newPlan =
        SemesterPlan(id: id, name: title, semester: semester, courses: []);
    plans.add(newPlan);
  }
}

class SemesterPlanFormController {
  var isSelected = [true, false].obs;

  void toggleSelection(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
  }
}
