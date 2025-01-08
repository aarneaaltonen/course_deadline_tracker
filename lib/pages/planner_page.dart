import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/courses_controller.dart';
import '../controllers/semester_plan_controller.dart';
import '../widgets/course_deadline_grid_container.dart';

class PlanPage extends StatelessWidget {
  final String id = Get.parameters['id']!;
  final planController = Get.find<SemesterPlanController>();
  final coursesController = Get.find<CourseController>();
  late final planData;

  @override
  Widget build(BuildContext context) {
    planData = planController.getPlanById(id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Get.offAllNamed('/home');
              },
            ),
            Text(planData.name),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Handle button press
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final courses = coursesController.fetchCoursesForPlan(id);
              return CourseDeadlineGridContainer(
                  courses: courses, semester: planData.semester, planId: id);
            }),
          ),
        ],
      ),
    );
  }
}
