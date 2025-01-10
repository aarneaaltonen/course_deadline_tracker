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

    // Calculate the left offset for the widget
    const double leftOffset = AppConstants.courseCardWidth;

    // Calculate the available width for the grid
    final double availableWidth = widgetWidth - AppConstants.calendarTailWidth;

    // Scale the difference in days to the available width
    final double scaledPosition =
        leftOffset + (daysDifference / totalDays) * availableWidth;

    return scaledPosition;
  }
}
