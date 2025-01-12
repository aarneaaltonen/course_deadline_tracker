import 'dart:async';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/models.dart';

class DeadlineCard extends StatefulWidget {
  final Deadline deadline;
  final String semester;

  DeadlineCard({required this.deadline, required this.semester});

  @override
  _DeadlineCardState createState() => _DeadlineCardState();
}

class _DeadlineCardState extends State<DeadlineCard> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.deadline.dueDate.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft = widget.deadline.dueDate.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getTimeLeftMessage() {
    if (_timeLeft.isNegative) {
      return "Deadline passed";
    } else if (_timeLeft.inDays > 0) {
      int days = _timeLeft.inDays;
      return "Due in $days days";
    } else {
      int hours = _timeLeft.inHours;
      int minutes = _timeLeft.inMinutes % 60;
      int seconds = _timeLeft.inSeconds % 60;
      return "Due in $hours hours, $minutes minutes, $seconds seconds";
    }
  }

  Color getDeadlineColor() {
    if (widget.deadline.isCompleted) {
      return Colors.green;
    } else if (widget.deadline.dueDate.isBefore(DateTime.now())) {
      return Colors.red;
    } else if (widget.deadline.dueDate.isBefore(
        DateTime.now().add(Duration(days: AppConstants.dangerZoneDays)))) {
      return const Color.fromARGB(255, 255, 190, 93);
    } else {
      return Color.fromARGB(255, 121, 215, 249);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: getTimeLeftMessage(),
      decoration: ShapeDecoration(
        color: getDeadlineColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 2.0,
          ),
        ),
      ),
      textStyle: TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 14,
      ),
      verticalOffset: 10,
      preferBelow: false,
      child: Card(
        color: getDeadlineColor(),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: SizedBox(
          width: AppConstants().getDeadlineCardWidth(),
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                // Move CustomPaint above the text
                CustomPaint(
                  size: Size(double.infinity, 20), // Customize the size
                  painter: DeadlineIndicatorPainter(
                      color: const Color.fromARGB(255, 0, 0, 0)),
                  child: Container(),
                ),
                Text(
                  widget.deadline.description,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeadlineIndicatorPainter extends CustomPainter {
  final Color color;

  DeadlineIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw a downward-pointing triangle (representing the end of the deadline)
    Path path = Path()
      ..moveTo(size.width - 5, -3) // Start at left point
      ..lineTo(size.width + 5, -3) // Right point
      ..lineTo(size.width, 2) // Top point (tail of the arrow)
      ..close();

    canvas.drawPath(path, paint);

    // Draw white border around the triangle
    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
