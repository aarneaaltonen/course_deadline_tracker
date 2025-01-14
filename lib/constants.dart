import 'package:aalto_course_tracker/controllers/warning_day_num_controller.dart';
import 'package:get/get.dart';
import '../controllers/scale_factor_controller.dart';

class AppConstants {
  final WarningDayNumController warningDayNumController =
      Get.find<WarningDayNumController>();
  static double get scalingFactor {
    final scaleFactorController = Get.find<ScaleFactorController>();
    return scaleFactorController.scaleFactor.value.toDouble();
  }

  static int get dangerZoneDays {
    final WarningDayNumController warningDayNumController =
        Get.find<WarningDayNumController>();
    return warningDayNumController.warningDayNum.value.toInt();
  }

  static const double courseCardWidth = 300;
  static const double calendarTailWidth = 1000;

  static const double dayWidth =
      4; //basic unit to calculate the width of the calendar

  double get springWidth => dayWidth * springDifference;
  double get autumnWidth => dayWidth * autumnDifference;

  double get scaledSpringWidth => springWidth * scalingFactor;
  double get scaledAutumnWidth => autumnWidth * scalingFactor;

  final DateTime springStartDate = DateTime(2025, 1, 6);
  final DateTime springEndDate = DateTime(2025, 6, 7);
  late final int springDifference;
  late final double periodHeaderWidth;
  final DateTime autumnStartDate = DateTime(2025, 8, 25);
  final DateTime autumnEndDate = DateTime(2025, 12, 14);
  late final int autumnDifference;
  late final double autumnPeriodHeaderWidth;

  final DateTime thirdPeriodStartDate = DateTime(2025, 1, 6);
  final DateTime thirdPeriodEndDate = DateTime(2025, 2, 23);
  final DateTime fourthPeriodStartDate = DateTime(2025, 2, 24);
  final DateTime fourthPeriodEndDate = DateTime(2025, 4, 13);
  final DateTime fifthPeriodStartDate = DateTime(2025, 4, 14);
  final DateTime fifthPeriodEndDate = DateTime(2025, 6, 6);

  final DateTime firstPeriodStartDate = DateTime(2025, 8, 25);
  final DateTime firstPeriodEndDate = DateTime(2025, 10, 19);
  final DateTime secondPeriodStartDate = DateTime(2025, 10, 20);
  final DateTime secondPeriodEndDate = DateTime(2025, 12, 14);

  AppConstants() {
    springDifference = daysBetween(springStartDate, springEndDate);
    autumnDifference = daysBetween(autumnStartDate, autumnEndDate);
    periodHeaderWidth = scalingFactor * springDifference;
    autumnPeriodHeaderWidth = scalingFactor * autumnDifference;
  }

  double getCalendarWidth(String semester) {
    return semester.toLowerCase() == 'spring'
        ? scaledSpringWidth + calendarTailWidth
        : scaledAutumnWidth + calendarTailWidth;
  }

  double getDeadlineCardWidth() {
    return scalingFactor *
        dayWidth *
        warningDayNumController.warningDayNum.value;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().abs();
  }

  int calculateSpringProgress() {
    final DateTime today = DateTime.now();
    if (today.isBefore(springStartDate)) {
      return 0;
    } else {
      final int daysFromStart = daysBetween(springStartDate, today);
      return daysFromStart;
    }
  }

  int calculateAutumnProgress() {
    final DateTime today = DateTime.now();
    if (today.isBefore(autumnStartDate)) {
      return 0;
    } else {
      final int daysFromStart = daysBetween(autumnStartDate, today);
      return daysFromStart;
    }
  }
}

class BreakPoints {
  static const double small = 600;
  static const double medium = 900;
  static const double large = 1200;
  static const double extraLarge = 1536;
}
