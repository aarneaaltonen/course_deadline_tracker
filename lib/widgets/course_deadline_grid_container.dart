import 'package:flutter/material.dart';

import '../constants.dart';
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

  CourseDeadlineGridContainer({
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
            child: SizedBox(
              width: AppConstants().springDifference *
                      AppConstants.scalingFactor *
                      (semester.toLowerCase() == 'autumn' ? 2 : 3) +
                  AppConstants.calendarTailWidth +
                  10,
              // something smarter here

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
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Add your edit period times logic here
                                },
                              )
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
                      final course = courses[index];
                      return CourseCardLane(course: course, semester: semester);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 40,
              child: Column(children: [
                for (var course in courses) CourseCard(course: course),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [AddCourseButton(semesterPlanId: planId)],
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
