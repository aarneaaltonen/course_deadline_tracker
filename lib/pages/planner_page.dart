import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/courses_controller.dart';
import '../controllers/semester_plan_controller.dart';
import '../widgets/add_course_ button.dart';

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
              icon: Icon(Icons.home),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddCourseButton(semesterPlanId: id),
          ),
          Expanded(
            child: Obx(() {
              final courses = coursesController.fetchCoursesForPlan(id);
              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(course.name),
                      subtitle: Text('ID: ${course.id}'),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
