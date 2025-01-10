import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/deadline_controller.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'grid_painter.dart';

class CourseCardLane extends StatelessWidget {
  final Course course;
  final String semester;
  final int index;
  final bool last;
  final List<Deadline> deadlines;
  final DeadlineController deadlineController = Get.find<DeadlineController>();

  CourseCardLane(
      {required this.course,
      required this.semester,
      required this.index,
      required this.last,
      required this.deadlines});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Row(
        children: [
          SizedBox(
            width: AppConstants().springDifference *
                    AppConstants.scalingFactor *
                    (semester.toLowerCase() == 'autumn' ? 2 : 3) +
                AppConstants.calendarTailWidth,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SizedBox(
                height: 80,
                child: Stack(children: [
                  CustomPaint(
                    painter: GridPainter(
                        semester: semester, index: index, last: last),
                    child: Container(), // Empty container to provide size
                  ),
                  ...deadlines.map((deadline) {
                    // Calculate the position of the deadline
                    double leftPosition = HelperFunctions()
                        .calculateLeftPosition(
                            deadline.dueDate,
                            AppConstants().springDifference *
                                    AppConstants.scalingFactor *
                                    (semester.toLowerCase() == 'autumn'
                                        ? 2
                                        : 3) +
                                AppConstants.calendarTailWidth,
                            semester); //TODO: smarter width stuff

                    return Positioned(
                      left: leftPosition,
                      top: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.event,
                        color: Colors.red,
                      ),
                    );
                  }),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
