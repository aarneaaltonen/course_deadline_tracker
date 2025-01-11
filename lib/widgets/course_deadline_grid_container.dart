import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/deadline_controller.dart';
import '../controllers/scale_factor_controller.dart';
import '../models/models.dart';
import 'add_course_ button.dart';

import 'course_card.dart';
import 'course_card_lane.dart';
import 'period_header.dart';

class CourseDeadlineGridContainer extends StatelessWidget {
  final List<Course> courses;
  final String semester;
  final String planId;
  final ScrollController scrollController;
  final scaleFactorController = Get.find<ScaleFactorController>();

  CourseDeadlineGridContainer({
    super.key,
    required this.courses,
    required this.semester,
    required this.planId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              double scaleFactor =
                  scaleFactorController.scaleFactor.value.toDouble();
              return SizedBox(
                width: AppConstants().springDifference *
                        scaleFactor *
                        (semester.toLowerCase() == 'autumn' ? 2 : 3) +
                    AppConstants.calendarTailWidth +
                    10,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: AppConstants.courseCardWidth,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Container()),
                              if (courses.isNotEmpty) EditButton(),
                            ],
                          ),
                        ),
                        if (courses.isNotEmpty)
                          if (semester.toLowerCase() == 'spring') ...[
                            PeriodHeader(periodText: 'III'),
                            SizedBox(width: 5),
                            PeriodHeader(periodText: 'IV'),
                            SizedBox(width: 5),
                            PeriodHeader(periodText: 'V'),
                          ] else if (semester.toLowerCase() == 'autumn') ...[
                            PeriodHeader(periodText: 'I'),
                            SizedBox(width: 5),
                            PeriodHeader(periodText: 'II'),
                          ],
                      ],
                    ),
                    ListView.builder(
                      itemCount: courses.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final DeadlineController deadlineController =
                            Get.find<DeadlineController>();
                        final course = courses[index];
                        return Obx(() {
                          final deadlines = deadlineController
                              .fetchDeadlinesForCourse(course.id)
                              .where(
                                  (deadline) => deadline.courseId == course.id)
                              .toList();
                          final last = index == courses.length - 1;
                          return CourseCardLane(
                            course: course,
                            semester: semester,
                            index: index,
                            last: last,
                            deadlines: deadlines,
                          );
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
          Positioned(
            top: 40,
            child: Column(
              children: [
                for (var course in courses) CourseCard(course: course),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [AddCourseButton(semesterPlanId: planId)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final scaleFactorController = Get.find<ScaleFactorController>();

  EditButton({super.key});
  @override
  Widget build(BuildContext context) {
    double scaleFactor = scaleFactorController.scaleFactor.value.toDouble();
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // Show Bottom Sheet with a slider
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Adjust Scale Factor',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Slider(
                        value: scaleFactor,
                        min: 1,
                        max: 20,
                        divisions: 19,
                        label: '${scaleFactor.round()}',
                        onChanged: (double value) {
                          setState(() {
                            scaleFactor = value;
                            scaleFactorController.setScaleFactor(value.toInt());
                          });
                        },
                        onChangeEnd: (double value) {
                          scaleFactorController
                              .setAndSaveScaleFactor(value.toInt());
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      tooltip: 'Change Calendar Scale',
    );
  }
}
