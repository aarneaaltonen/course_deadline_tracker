import 'dart:async';
import 'package:aalto_course_tracker/widgets/deadline_info_content.dart';
import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../constants.dart';
import '../models/models.dart';
import '../painters/deadline_indicator_painter.dart';

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

  Color getDeadlineColor(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.deadline.isCompleted) {
      return isDarkMode ? const Color.fromARGB(255, 44, 122, 48) : Colors.green;
    } else if (widget.deadline.dueDate.isBefore(DateTime.now())) {
      return isDarkMode
          ? const Color.fromARGB(255, 150, 26, 26)
          : const Color.fromARGB(255, 255, 116, 107);
    } else if (widget.deadline.dueDate.isBefore(
        DateTime.now().add(Duration(days: AppConstants.dangerZoneDays)))) {
      return isDarkMode
          ? const Color.fromARGB(255, 178, 98, 0)
          : const Color.fromARGB(255, 255, 190, 93);
    } else {
      return isDarkMode
          ? Color.fromARGB(255, 89, 61, 133)
          : Color.fromARGB(255, 121, 215, 249);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Tooltip(
      message: getTimeLeftMessage(),
      decoration: ShapeDecoration(
        color: getDeadlineColor(context),
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
        color: getDeadlineColor(context),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: SizedBox(
          width: AppConstants().getDeadlineCardWidth(),
          child: InkWell(
            hoverColor:
                const Color.fromARGB(193, 255, 255, 255).withValues(alpha: 0.4),
            onTap: () {
              if (size.width > BreakPoints.medium) {
                showModalSideSheet(
                    //here just waiting for this to be implemented for flutter web
                    context: context,
                    barrierDismissible: true,
                    barrierColor: const Color.fromARGB(9, 0, 0, 0),
                    ignoreAppBar: false,
                    width: size.width * 0.3,
                    body: DeadlineInfoContent(deadline: widget.deadline));
              } else {
                showBottomSheet(
                  context: context,
                  builder: (context) {
                    return DeadlineInfoContent(deadline: widget.deadline);
                  },
                );
              }
            },
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
                  maxLines: 1,
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
