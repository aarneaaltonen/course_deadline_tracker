import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/deadline_controller.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'deadline_card.dart';
import '../painters/grid_painter.dart';

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
            width: AppConstants().getCalendarWidth(semester),
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
        deadline.dueDate,
        AppConstants().getCalendarWidth(semester),
        semester,
      );

      // finds the last available row, or picks the row with the furthest last deadline to show the card as much as possible
      int selectedRow = 0;
      double deadlineWidth = AppConstants().getDeadlineCardWidth();
      for (int row = 0; row < rowHeights.length; row++) {
        if (!occupiedRows.containsKey(row) ||
            leftPosition - (occupiedRows[row] ?? 0) >= deadlineWidth) {
          selectedRow = row;
          break;
        }
        if (row == rowHeights.length - 1) {
          final int rowWithFurthestLastDeadline = occupiedRows.entries
              .reduce((a, b) => a.value < b.value ? a : b)
              .key;
          selectedRow = rowWithFurthestLastDeadline;
        }
      }

      deadlineWidgets.add(
        Positioned(
          top: rowHeights[selectedRow],
          left: leftPosition -
              (deadlineWidth + 5), //TODO: find out why +5 is needed
          child: SizedBox(
            height: 30,
            child: DeadlineCard(deadline: deadline, semester: semester),
          ),
        ),
      );

      occupiedRows[selectedRow] = leftPosition;
    }

    return deadlineWidgets;
  }
}
