import 'package:aalto_course_tracker/widgets/add_deadline_button.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/models.dart';
import 'add_course_ button.dart';
import 'course_card.dart';
import 'period_header.dart';

class CourseDeadlineGridContainer extends StatelessWidget {
  final List<Course> courses;
  final String semester;
  final String planId;

  CourseDeadlineGridContainer(
      {required this.courses, required this.semester, required this.planId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: AppConstants().springDifference *
                      AppConstants.scalingFactor *
                      (semester.toLowerCase() == 'autumn' ? 2 : 3) +
                  310,
              // something smarter here

              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Add your edit period times logic here
                                },
                              )
                            ],
                          ),
                        ),
                      ),
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
                      return CourseCard(course: course, semester: semester);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 56,
              child: Column(children: [
                for (var course in courses)
                  Card(
                    color: Color(int.parse(course.color)),
                    child: SizedBox(
                      width: (size.width < BreakPoints.small)
                          ? 80
                          : (size.width < BreakPoints.medium)
                              ? 150
                              : 300,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                course.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(child: Container()),
                            AddDeadlineButton(courseId: course.id),
                          ],
                        ),
                      ),
                    ),
                  ),
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
