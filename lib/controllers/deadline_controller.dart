import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

class DeadlineController {
  final storage = Hive.box('storage');

  RxList<Deadline> deadlines = <Deadline>[].obs;

  DeadlineController() {
    if (storage.get('deadlines') == null) {
      storage.put('deadlines', []);
    }
    final storedDeadlines = storage.get('deadlines') as List;
    deadlines.value = storedDeadlines.map((deadline) {
      final deadlineMap = Map<String, dynamic>.from(deadline as Map);
      return Deadline.fromJson(deadlineMap);
    }).toList();
  }

  void _save() {
    storage.put(
        'deadlines', deadlines.map((deadline) => deadline.toJson()).toList());
  }

  void addDeadline(
      String courseId, DateTime date, TimeOfDay? time, String description) {
    final uuid = Uuid();
    final id = uuid.v4();
    DateTime combined =
        combineDateAndTime(date, time ?? TimeOfDay(hour: 23, minute: 59));

    final newDeadline = Deadline(
      id: id,
      courseId: courseId,
      dueDate: combined,
      description: description,
    );
    deadlines.add(newDeadline);
    _save();
  }

  void listDeadlines(String courseId) {
    deadlines
        .where((deadline) => deadline.courseId == courseId)
        .forEach((deadline) {});
  }

  RxList<Deadline> fetchDeadlinesForCourse(String courseId) {
    return deadlines
        .where((deadline) => deadline.courseId == courseId)
        .toList()
        .obs;
  }

  void deleteDeadline(String id) {
    deadlines.removeWhere((deadline) => deadline.id == id);
    _save();
  }

  void updateDeadline(Deadline deadline) {
    final index = deadlines.indexWhere((d) => d.id == deadline.id);
    deadlines[index] = deadline;
    _save();
  }
}

DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
