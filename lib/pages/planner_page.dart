import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/courses_controller.dart';
import '../controllers/semester_plan_controller.dart';

import '../widgets/course_deadline_grid_container.dart';

class PlanPage extends StatelessWidget {
  final String id = Get.parameters['id']!;
  final planController = Get.find<SemesterPlanController>();
  final coursesController = Get.find<CourseController>();
  final ScrollController scrollController = ScrollController();

//bring view to progress on first load
  void _scrollToProgress() {
    // Calculate the scroll position based on the progress
    final planController = Get.find<SemesterPlanController>();
    final planData = planController.getPlanById(id);
    if (planData != null) {
      //TODO: make util for calculating progress
      final int springProgress = AppConstants().calculateSpringProgress();
      final int autumnProgress = AppConstants().calculateAutumnProgress();
      const double leftOffset = AppConstants.courseCardWidth;
      final double size = AppConstants().springDifference *
              AppConstants.scalingFactor *
              (planData.semester.toLowerCase() == 'autumn' ? 2 : 3) +
          leftOffset; //might make a callback for this, requires semester info

      final double availableWidth = size - leftOffset;
      final AppConstants constants = AppConstants();
      final int totalDays = planData.semester.toLowerCase() == 'spring'
          ? constants.springDifference
          : constants.autumnDifference;
      double progressX;

      if (planData.semester.toLowerCase() == 'spring') {
        progressX =
            leftOffset + (springProgress / (totalDays)) * availableWidth;
      } else {
        progressX =
            leftOffset + (autumnProgress / (totalDays)) * availableWidth;
      }
      if (scrollController.hasClients) {
        double cardProgress;
        final screenWidth = MediaQuery.of(Get.context!).size.width;
        if (screenWidth < BreakPoints.small) {
          cardProgress = progressX -
              200; //bring closer to progress bar if screen (and cards) are smaller
        } else if (screenWidth < BreakPoints.medium) {
          cardProgress = progressX - 250;
        } else {
          cardProgress = progressX - 400;
        }

        scrollController.animateTo(
          cardProgress,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final planData = planController.getPlanById(id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToProgress();
    });

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
            Text(planData!.name),
            IconButton(
              icon: Icon(Icons.format_list_bulleted,
                  color: const Color.fromARGB(255, 0, 0, 0)),
              tooltip: "View Deadlines",
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
                  courses: courses,
                  semester: planData.semester,
                  planId: id,
                  scrollController: scrollController);
            }),
          ),
        ],
      ),
    );
  }
}
