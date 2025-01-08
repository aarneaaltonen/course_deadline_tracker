import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

class CourseController {
  final storage = Hive.box('storage');

  RxList<Course> courses = <Course>[].obs;

  CourseController() {
    if (storage.get('courses') == null) {
      storage.put('courses', []);
    }
    final storedCourses = storage.get('courses') as List;
    courses.value = storedCourses.map((course) {
      final courseMap = Map<String, dynamic>.from(course as Map);
      return Course.fromJson(courseMap);
    }).toList();
  }

  void _save() {
    storage.put('courses', courses.map((course) => course.toJson()).toList());
  }

  void addCourse(String courseName, String semesterPlanId) {
    final uuid = Uuid();
    final id = uuid.v4();
    final newCourse = Course(
      id: id,
      semesterPlanId: semesterPlanId,
      name: courseName,
      deadlines: [],
    );
    courses.add(newCourse);
    _save();
  }

  void listCourses(String semesterPlanId) {
    courses
        .where((course) => course.semesterPlanId == semesterPlanId)
        .forEach((course) {});
  }

  List<Course> fetchCoursesForPlan(String semesterPlanId) {
    return courses
        .where((course) => course.semesterPlanId == semesterPlanId)
        .toList();
  }
}
