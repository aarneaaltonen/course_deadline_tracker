import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/models.dart';

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
                300,
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
  //draws week lines and progress line
  final String semester;

  GridPainter({required this.semester});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 201, 201, 201)
      ..strokeWidth = 1.0;

    double interval = (AppConstants().springDifference *
            AppConstants.scalingFactor) /
        7.1; //show interval line every seven days, bunch of little rounding errors and the fact that years are 365.25 days long
    //kinda culminates in the progress line being off relative week lines by a few pixels

    for (double x = 0; x <= size.width; x += interval) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    if (true) {
      final int springProgress = AppConstants().calculateSpringProgress();
      final double autumnProgress = AppConstants().calculateAutumnProgress();
      double progressX;
      if (semester.toLowerCase() == 'spring') {
        progressX =
            springProgress / AppConstants().springDifference * size.width + 310;
      } else {
        progressX = autumnProgress * size.width;
      }

      final progressPaint = Paint()
        ..color = const Color.fromARGB(255, 114, 0, 116)
        ..strokeWidth = 2.0;

      canvas.drawLine(Offset(progressX, -5), Offset(progressX, size.height + 5),
          progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
