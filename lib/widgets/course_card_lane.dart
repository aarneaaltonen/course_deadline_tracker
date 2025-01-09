import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/models.dart';
import 'package:intl/intl.dart' as intl;

class CourseCardLane extends StatelessWidget {
  final Course course;
  final String semester;

  CourseCardLane({required this.course, required this.semester});

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
                child: CustomPaint(
                  painter: GridPainter(semester: semester),
                  child: Container(), // Empty container to provide size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final String semester;

  GridPainter({required this.semester});

  @override
  void paint(Canvas canvas, Size size) {
    const double leftOffset = AppConstants.courseCardWidth;
    final double availableWidth = size.width - AppConstants.calendarTailWidth;

    final AppConstants constants = AppConstants();
    final int totalDays = semester.toLowerCase() == 'spring'
        ? constants.springDifference
        : constants.autumnDifference;

    //day lines
    final dayPaint = Paint()
      ..color = const Color.fromARGB(100, 201, 201, 201)
      ..strokeWidth = 0.5;

    for (int i = 0; i < totalDays + 10; i++) {
      double x = leftOffset + (i / totalDays) * availableWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), dayPaint);

      //week lines
      if (i % 7 == 0) {
        final paint = Paint()
          ..color = const Color.fromARGB(255, 93, 93, 93)
          ..strokeWidth = 1.0;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
        final textPainter = TextPainter(
          text: TextSpan(
            text: intl.DateFormat.MMMd().format(
              semester.toLowerCase() == 'spring'
                  ? constants.springStartDate.add(Duration(days: i))
                  : constants.autumnStartDate.add(Duration(days: i)),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x + 2, size.height - 12));
      }
    }

//progress bar, this implementation does not consider time of the day //TODO: add?
    final int springProgress = constants.calculateSpringProgress();
    final int autumnProgress = constants.calculateAutumnProgress();
    double progressX;

    if (semester.toLowerCase() == 'spring') {
      progressX = leftOffset + (springProgress / (totalDays)) * availableWidth;
    } else {
      progressX = leftOffset + (autumnProgress / (totalDays)) * availableWidth;
    }

    final progressPaint = Paint()
      ..color = const Color.fromARGB(255, 114, 0, 116)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(progressX, -5),
      Offset(progressX, size.height + 5),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
