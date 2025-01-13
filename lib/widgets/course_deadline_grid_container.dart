import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/deadline_controller.dart';
import '../controllers/scale_factor_controller.dart';
import '../models/models.dart';
import 'add_course_button.dart';

import 'course_card.dart';
import 'course_card_lane.dart';
import 'edit_calendar_scale_button.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return SizedBox(
                    width: AppConstants().getCalendarWidth(semester) + 10,
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
                                  if (courses.isNotEmpty)
                                    EditCalendarScaleButton(),
                                ],
                              ),
                            ),
                            if (courses.isNotEmpty)
                              if (semester.toLowerCase() == 'spring') ...[
                                PeriodHeader(
                                    periodText: 'III',
                                    startDate:
                                        AppConstants().thirdPeriodStartDate,
                                    endDate: AppConstants().thirdPeriodEndDate),
                                SizedBox(
                                    width: AppConstants.scalingFactor *
                                        AppConstants.dayWidth /
                                        2),
                                PeriodHeader(
                                    periodText: 'IV',
                                    startDate:
                                        AppConstants().fourthPeriodStartDate,
                                    endDate:
                                        AppConstants().fourthPeriodEndDate),
                                SizedBox(
                                    width: AppConstants.scalingFactor *
                                        AppConstants.dayWidth /
                                        2),
                                PeriodHeader(
                                    periodText: 'V',
                                    startDate:
                                        AppConstants().fifthPeriodStartDate,
                                    endDate: AppConstants().fifthPeriodEndDate),
                              ] else if (semester.toLowerCase() ==
                                  'autumn') ...[
                                PeriodHeader(
                                    periodText: 'I',
                                    startDate:
                                        AppConstants().firstPeriodStartDate,
                                    endDate: AppConstants().firstPeriodEndDate),
                                SizedBox(
                                    width: AppConstants.scalingFactor *
                                        AppConstants.dayWidth /
                                        2),
                                PeriodHeader(
                                    periodText: 'II',
                                    startDate:
                                        AppConstants().secondPeriodStartDate,
                                    endDate:
                                        AppConstants().secondPeriodEndDate),
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
                                  .where((deadline) =>
                                      deadline.courseId == course.id)
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
                        SizedBox(height: 200),
                      ],
                    ),
                  );
                }),
              ),
              Positioned(
                left: courses.isEmpty ? (constraints.maxWidth / 2) - 150 : 0,
                top: 40, //should prolly use layoutbuilder to get the height
                child: Column(
                  children: [
                    for (var course in courses) CourseCard(course: course),
                    SizedBox(height: 10),
                    if (courses.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add a course to get started!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            AddCourseButton(semesterPlanId: planId),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [AddCourseButton(semesterPlanId: planId)],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
