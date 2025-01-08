import 'package:aalto_course_tracker/controllers/courses_controller.dart';
import 'package:aalto_course_tracker/controllers/semester_plan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'pages/planner_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('storage');
  await dotenv.load(fileName: ".env");
  Get.put<CourseController>(CourseController());
  Get.put<SemesterPlanController>(SemesterPlanController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 156, 183)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/plan/:id', page: () => PlanPage()),
      ],
    );
  }
}
