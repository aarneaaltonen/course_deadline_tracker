import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/semester_plan_controller.dart';
import '../widgets/add_course_ button.dart';

class PlanPage extends StatelessWidget {
  final String id = Get.parameters['id']!;

  final planController = Get.find<SemesterPlanController>();
  late final planData;

  @override
  Widget build(BuildContext context) {
    planData = planController.getPlanById(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(planData.name),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
                'Extract plan data here for ${planData.name}, from hive storage'),
          ),
          AddCourseButton(), // Add the AddCourseButton here
        ],
      ),
    );
  }
}
