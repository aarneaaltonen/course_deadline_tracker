import 'package:get/get.dart';

class UpcomingDeadlinesController extends GetxController {
  var upcomingDeadlineCount = 0.obs;

  void updateCount(int count) {
    upcomingDeadlineCount.value = count;
  }
}
