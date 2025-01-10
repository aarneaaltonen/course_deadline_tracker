class AppConstants {
  static const double scalingFactor = 55;
  static const double courseCardWidth = 300;
  static const double calendarTailWidth = 1000;
  static final double deadlineCardWidth = 15 * scalingFactor;

  final DateTime springStartDate = DateTime(2025, 1, 6);
  final DateTime springEndDate = DateTime(2025, 6, 7);
  late final int springDifference;
  late final double periodHeaderWidth;

  final DateTime autumnStartDate = DateTime(2025, 8, 25);
  final DateTime autumnEndDate = DateTime(2025, 12, 14);
  late final int autumnDifference;
  late final double autumnPeriodHeaderWidth;

  AppConstants() {
    springDifference = daysBetween(springStartDate, springEndDate);
    periodHeaderWidth = scalingFactor * springDifference;
    autumnDifference = daysBetween(autumnStartDate, autumnEndDate);
    autumnPeriodHeaderWidth = scalingFactor * autumnDifference;
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
