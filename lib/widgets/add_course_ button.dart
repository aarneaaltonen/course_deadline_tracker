import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class CourseApiController extends GetxController {
  List<Course>? courseList;
  var apiCourseData = [].obs;

  Future<void> fetchapiCourseData() async {
    final userKey = dotenv.env['USER_KEY'];
    final response = await http.get(
      Uri.parse(
          //Todo: replace with the correct endpoint AND CACHE
          'https://course.api.aalto.fi:443/api/sisu/v1/courseunits?user_key=$userKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      apiCourseData.value =
          data; // Assuming the response is a single course object
    } else {
      throw Exception('Failed to load course data');
    }
  }
}

//TODO: add state management for the searched
//TODO: refactor, button opens form modal, form fetches course data
class AddCourseButton extends StatelessWidget {
  final CourseApiController courseController = Get.put(CourseApiController());

  @override
  Widget build(BuildContext context) {
    courseController.fetchapiCourseData();
    return Column(
      children: [
        Obx(() {
          if (courseController.apiCourseData.isEmpty) {
            return Center(child: Text('No course data'));
          }
          return DropdownMenu(
            dropdownMenuEntries: [
              for (var course in courseController.apiCourseData.take(10))
                DropdownMenuEntry(
                  label:
                      '${course['code']} ${course['name']?['en'] ?? 'No name'}',
                  value: course['code'] ?? 'No code',
                )
            ],
          );
        }),
      ],
    );
  }
}
