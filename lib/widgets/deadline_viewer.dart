import 'package:aalto_course_tracker/controllers/upcoming_deadlines_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../constants.dart';
import '../controllers/courses_controller.dart';
import '../controllers/deadline_controller.dart';
import '../controllers/standard_side_sheet_controller.dart';
import '../controllers/warning_day_num_controller.dart';
import '../models/models.dart';
import 'deadline_info_content.dart';

//TODO: add slider to change card width ("danger zone" for deadlines)
//TODO: add indicator to icon for each deadline in "danger zone"
class DeadlineViewer extends StatelessWidget {
  final SemesterPlan planData;
  final openController = Get.find<StandardSideSheetController>();
  final deadlineController = Get.find<DeadlineController>();
  final coursesController = Get.find<CourseController>();
  final UpcomingDeadlinesController upcomingDeadlinesController =
      Get.find<UpcomingDeadlinesController>();
  final WarningDayNumController warningDayNumController =
      Get.find<WarningDayNumController>();

  DeadlineViewer({super.key, required this.planData});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coursesForPlan = coursesController.fetchCoursesForPlan(planData.id);
      List<Deadline> planDeadlines = [];
      for (var course in coursesForPlan) {
        planDeadlines
            .addAll(deadlineController.fetchDeadlinesForCourse(course.id));
      }

      planDeadlines.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      // Separate deadlines into completed/overdue and pending
      final completedOrOverdueDeadlines = planDeadlines.where((deadline) {
        return deadline.isCompleted ||
            deadline.dueDate.isBefore(DateTime.now());
      }).toList();

      final pendingDeadlines = planDeadlines.where((deadline) {
        return !deadline.isCompleted &&
            !deadline.dueDate.isBefore(DateTime.now());
      }).toList();
      final dangerZoneDeadlines = pendingDeadlines.where((deadline) {
        return deadline.dueDate.isBefore(DateTime.now()
            .add(Duration(days: warningDayNumController.warningDayNum.value)));
      }).toList();

      // Update the count of upcoming deadlines
      WidgetsBinding.instance.addPostFrameCallback((_) {
        upcomingDeadlinesController.updateCount(dangerZoneDeadlines.length);
      });

      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deadlines',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    openController.toggleSideSheet();
                  },
                  tooltip: "Close",
                ),
              ],
            ),
            SizedBox(height: 8.0),
            if (planDeadlines.isEmpty)
              Center(
                child: Text('No deadlines available for this plan.'),
              ),
            if (planDeadlines.isNotEmpty)
              Expanded(
                child: Row(
                  children: [
                    // Completed/Overdue Deadlines List
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Completed/Overdue',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: completedOrOverdueDeadlines
                                    .map((deadline) => DeadlineViewerCard(
                                          deadline: deadline,
                                          context: context,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: pendingDeadlines
                                    .map((deadline) => DeadlineViewerCard(
                                          deadline: deadline,
                                          context: context,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 100.0,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Change warning day amount',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Obx(() {
                          return Expanded(
                            child: Slider(
                              value: warningDayNumController.warningDayNum.value
                                  .toDouble(),
                              min: 1.0,
                              max: 10.0,
                              divisions: 9,
                              label: warningDayNumController.warningDayNum.value
                                  .toString(),
                              onChanged: (double value) {
                                warningDayNumController
                                    .setWarningDayNum(value.toInt());
                              },
                              onChangeEnd: (double value) {
                                warningDayNumController
                                    .setAndSaveWarningDayNum(value.toInt());
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                    Text(
                      "The warning day number indicates how many days before a deadline the service visually distinguishes it. Deadlines within the 'danger zone' are highlighted in orange.",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class DeadlineViewerCard extends StatelessWidget {
  final Deadline deadline;
  final BuildContext context;
  final deadlineController = Get.find<DeadlineController>();

  DeadlineViewerCard({
    super.key,
    required this.deadline,
    required this.context,
  });

  Color getDeadlineColor(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (deadline.isCompleted) {
      return isDarkMode ? const Color.fromARGB(255, 44, 122, 48) : Colors.green;
    } else if (deadline.dueDate.isBefore(DateTime.now())) {
      return isDarkMode
          ? const Color.fromARGB(255, 150, 26, 26)
          : const Color.fromARGB(255, 255, 116, 107);
    } else if (deadline.dueDate.isBefore(
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
    final borderColor = getDeadlineColor(context);
    final size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalSideSheet(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: const Color.fromARGB(9, 0, 0, 0),
                          ignoreAppBar: false,
                          width: size.width * 0.3,
                          body: DeadlineInfoContent(deadline: deadline));
                    },
                    child: Text(
                      deadline.description,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Tooltip(
                  message: deadline.isCompleted
                      ? 'Mark as incomplete'
                      : 'Mark as complete',
                  child: Checkbox(
                    value: deadline.isCompleted,
                    onChanged: (value) {
                      final updatedDeadline = Deadline(
                        id: deadline.id,
                        courseId: deadline.courseId,
                        description: deadline.description,
                        dueDate: deadline.dueDate,
                        isCompleted: value ?? false,
                      );
                      deadlineController.updateDeadline(updatedDeadline);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              'Due on: ${DateFormat.yMMMd().format(deadline.dueDate)}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
