class AppConstants {
  static const double scalingFactor = 5;
  var springStartDate = DateTime(2025, 1, 6);
  var springEndDate = DateTime(2025, 6, 6);
  late int springDifference;
  late double periodHeaderWidth = scalingFactor * springDifference;

  int calculateSpringProgress() {
    final DateTime today = DateTime.now();
    if (today.isBefore(springStartDate)) {
      return 0;
    } else if (today.isAfter(springEndDate)) {
      return 0;
    } else {
      final int daysFromStart = today.difference(springStartDate).inDays;

      return daysFromStart;
    }
  }

  var autumnStartDate = DateTime(2025, 8, 25);
  var autumnEndDate = DateTime(2025, 12, 14);
  late int autumnDifference;
  late double autumnPeriodHeaderWidth = scalingFactor * autumnDifference;

  AppConstants() {
    springDifference = springEndDate.difference(springStartDate).inDays;
    autumnDifference = autumnEndDate.difference(autumnStartDate).inDays;
  }

  double calculateAutumnProgress() {
    final DateTime today = DateTime.now();
    if (today.isBefore(autumnStartDate)) {
      return 0.0;
    } else if (today.isAfter(autumnEndDate)) {
      return 1.0;
    } else {
      final int daysFromStart = today.difference(autumnStartDate).inDays;
      return daysFromStart / autumnDifference;
    }
  }
}

class BreakPoints {
  static const double small = 600;
  static const double medium = 900;
  static const double large = 1200;
  static const double extraLarge = 1536;
}
