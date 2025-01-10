import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/deadline_controller.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'deadline_card.dart';
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
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: IntervalPainter(
                        semester: semester,
                        index: index,
                        last: last,
                      ),
                      child: Container(), // Day lines at the back
                    ),
                    ..._buildDeadlineWidgets(), // Deadline cards go first
                    IgnorePointer(
                      child: CustomPaint(
                        painter: ProgressBarPainter(
                          semester: semester,
                          index: index,
                          last: last,
                        ),
                        child: Container(), // Empty container to provide size
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDeadlineWidgets() {
    List<Widget> deadlineWidgets = [];
    List<double> rowHeights = [0, 25, 50]; // Predefined row heights
    Map<int, double> occupiedRows =
        {}; // Tracks the last left position for each row

    // Sort deadlines by due date
    deadlines.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    for (var deadline in deadlines) {
      // Calculate the left position of the deadline
      double leftPosition = HelperFunctions().calculateLeftPosition(
        deadline.dueDate.add(Duration(
            days:
                1)), //add one day since "deadline" is usually concidered the last day
        AppConstants().springDifference *
                AppConstants.scalingFactor *
                (semester.toLowerCase() == 'autumn' ? 2 : 3) +
            AppConstants.calendarTailWidth,
        semester,
      );

      // Find the first available row
      int selectedRow = 0;
      for (int row = 0; row < rowHeights.length; row++) {
        if (!occupiedRows.containsKey(row) ||
            leftPosition - (occupiedRows[row] ?? 0) >=
                AppConstants.deadlineCardWidth) {
          selectedRow = row;
          break;
        }
      }

      // Add the DeadlineCard to the selected row
      deadlineWidgets.add(
        Positioned(
          top: rowHeights[selectedRow],
          left: leftPosition - AppConstants.deadlineCardWidth,
          child: SizedBox(
            height: 30,
            child: DeadlineCard(deadline: deadline),
          ),
        ),
      );

      // Mark the row as occupied at this position
      occupiedRows[selectedRow] = leftPosition;
    }

    return deadlineWidgets;
  }
}
