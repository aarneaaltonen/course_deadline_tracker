import 'package:aalto_course_tracker/models/models.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

//TODO: might refactor some logic to a service file
class SemesterPlanController {
  final storage = Hive.box('storage');

  RxList<SemesterPlan> plans = <SemesterPlan>[].obs;

  SemesterPlanController() {
    if (storage.get('plans') == null) {
      storage.put('plans', []);
    }
    final storedPlans = storage.get('plans') as List;
    plans.value = storedPlans.map((plan) {
      final planMap = Map<String, dynamic>.from(plan as Map);
      return SemesterPlan.fromJson(planMap);
    }).toList();
  }

  void _save() {
    storage.put('plans', plans.map((plan) => plan.toJson()).toList());
  }

  void addPlan(String title, String semester) {
    final uuid = Uuid();
    final id = uuid.v4();
    final newPlan =
        SemesterPlan(id: id, name: title, semester: semester, courses: []);
    plans.add(newPlan);
    _save();
  }

  void deletePlan(String id) {
    plans.removeWhere((plan) => plan.id == id);
    _save();
  }

  SemesterPlan? getPlanById(String id) {
    try {
      return plans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null; // Return null if no plan is found with the given ID
    }
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
