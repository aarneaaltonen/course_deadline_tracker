import 'package:aalto_course_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:intl/intl.dart' as intl;

//this painter paints the grid, the interval bars, the dates, and the progress bar
class ProgressBarPainter extends CustomPainter {
  final String semester;
  final int index;
  final bool last;

  ProgressBarPainter(
      {required this.semester, required this.index, required this.last});

  @override
  void paint(Canvas canvas, Size size) {
    final double availableWidth = size.width - AppConstants.calendarTailWidth;

    final AppConstants constants = AppConstants();
    final int totalDays = semester.toLowerCase() == 'spring'
        ? constants.springDifference
        : constants.autumnDifference;

    //progress bar
    final DateTime now = DateTime.now();
    double progressX =
        HelperFunctions().calculateLeftPosition(now, size.width, semester);

    final int currentHour = now.hour;
    final double hourProgress = currentHour / 24;
    progressX += (hourProgress / totalDays) * availableWidth;

    final progressPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(progressX, -5),
      Offset(progressX, size.height + 5),
      progressPaint,
    );
    if (last) {
      final Path trianglePath = Path()
        ..moveTo(progressX, size.height)
        ..lineTo(progressX - 10, size.height + 10)
        ..lineTo(progressX + 10, size.height + 10)
        ..close();

      canvas.drawPath(trianglePath, progressPaint);
    }
    if (index == 0) {
      final Path trianglePath = Path()
        ..moveTo(progressX, 0)
        ..lineTo(progressX - 10, -10)
        ..lineTo(progressX + 10, -10)
        ..close();

      canvas.drawPath(trianglePath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class IntervalPainter extends CustomPainter {
  final String semester;
  final int index;
  final bool last;

  IntervalPainter(
      {required this.semester, required this.index, required this.last});

  @override
  void paint(Canvas canvas, Size size) {
    const double leftOffset = AppConstants.courseCardWidth;
    final double availableWidth = size.width - AppConstants.calendarTailWidth;

    final AppConstants constants = AppConstants();
    final int totalDays = semester.toLowerCase() == 'spring'
        ? constants.springDifference
        : constants.autumnDifference;

    // Day lines
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
        // if (last) { //show date only on bottom course, less buzy
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
        // }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
