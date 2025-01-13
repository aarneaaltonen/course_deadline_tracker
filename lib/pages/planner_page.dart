import 'package:aalto_course_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/courses_controller.dart';
import '../controllers/semester_plan_controller.dart';

import '../widgets/course_deadline_grid_container.dart';
import '../widgets/edit_calendar_scale_button.dart';

// ignore: must_be_immutable
class PlanPage extends StatelessWidget {
  final String id = Get.parameters['id']!;
  final planController = Get.find<SemesterPlanController>();
  final coursesController = Get.find<CourseController>();
  final ScrollController scrollController = ScrollController();
  bool shouldScrollToProgress =
      true; //added this to prevent scrolling on every rerender

//bring view to progress on first load
  void _scrollToProgress() {
    if (!shouldScrollToProgress) return;
    // Calculate the scroll position based on the progress
    final planController = Get.find<SemesterPlanController>();
    final planData = planController.getPlanById(id);
    if (planData != null) {
      final DateTime today = DateTime.now();

      final double size = AppConstants().getCalendarWidth(planData.semester);

      double progressX = HelperFunctions()
          .calculateLeftPosition(today, size, planData.semester);

      if (scrollController.hasClients) {
        double cardProgress;
        final screenWidth = MediaQuery.of(Get.context!).size.width;
        if (screenWidth < BreakPoints.small) {
          cardProgress = progressX -
              200; //bring closer to progress bar if screen (and cards) are smaller
        } else if (screenWidth < BreakPoints.medium) {
          cardProgress = progressX - 250;
        } else {
          cardProgress = progressX - 500;
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
      shouldScrollToProgress = false;
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
            Spacer(),
            Text(planData!.name),
            Spacer(),
            ThemeToggleSwitch(),
            EditCalendarScaleButton(),
            // IconButton(
            //   icon: Icon(Icons.format_list_bulleted,
            //       color: const Color.fromARGB(255, 0, 0, 0)),
            //   tooltip: "View Deadlines",
            //   onPressed: () {
            //     // Handle button press
            //   },
            // ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 4),
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
