import 'package:flutter/material.dart';

import '../models/models.dart';
import 'add_course_ button.dart';
import 'course_card.dart';

class CourseDeadlineGridContainer extends StatelessWidget {
  final List<Course> courses;
  final String semester;
  final String planId;
  final double periodHeaderWidth = 600.0;

  CourseDeadlineGridContainer(
      {required this.courses, required this.semester, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: periodHeaderWidth * 3 + 320, // something smarter here
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
                    SizedBox(
                      width: periodHeaderWidth,
                      child: Container(
                        height: 40,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'I',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: periodHeaderWidth,
                      child: Container(
                        height: 40,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'II',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: periodHeaderWidth,
                      child: Container(
                        height: 40,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'III',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ] else if (semester.toLowerCase() == 'autumn') ...[
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'I',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5), // Spacing between containers
                    Expanded(
                      child: Container(
                        height: 40,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'II',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(course: course);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [AddCourseButton(semesterPlanId: planId)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
