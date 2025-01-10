import '../constants.dart';

class HelperFunctions {
  double calculateLeftPosition(
      DateTime dueDate, double widgetWidth, String semester) {
    // Determine the start date of the semester
    final DateTime startDate = semester.toLowerCase() == 'spring'
        ? AppConstants().springStartDate
        : AppConstants().autumnStartDate;

    // Total number of days in the semester
    final int totalDays = semester.toLowerCase() == 'spring'
        ? AppConstants().springDifference
        : AppConstants().autumnDifference;

    // Calculate the difference in days between the due date and the start date
    final int daysDifference = dueDate.difference(startDate).inDays;

    // Calculate the fraction of the current day based on the time
    final double timeFraction = (dueDate.hour + dueDate.minute / 60.0) / 24.0;

    // Total day progress including the time contribution
    final double totalDayProgress = daysDifference + timeFraction;

    // Calculate the left offset for the widget
    const double leftOffset = AppConstants.courseCardWidth;

    // Calculate the available width for the grid
    final double availableWidth = widgetWidth - AppConstants.calendarTailWidth;

    // Calculate the scaled position including day progress
    final double scaledPosition =
        leftOffset + (totalDayProgress / totalDays) * availableWidth;

    return scaledPosition;
  }
}
