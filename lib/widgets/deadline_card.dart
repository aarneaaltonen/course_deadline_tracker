import 'package:aalto_course_tracker/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../models/models.dart';

class DeadlineCard extends StatelessWidget {
  final Deadline deadline;

  DeadlineCard({required this.deadline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.deadlineCardWidth,
      child: InkWell(
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: Text(deadline.description),
              content: Text(
                  'Details about the deadline: ${deadline.description}, due on ${deadline.dueDate}'),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: Card(
          color: const Color.fromARGB(255, 121, 215, 249),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: const Color.fromARGB(255, 156, 156, 156),
              width: 1.0,
            ),
          ),
          child: Column(children: [
            Text(
              deadline.description,
              style: TextStyle(fontSize: 13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    );
  }
}
