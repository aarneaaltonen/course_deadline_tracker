import 'package:aalto_course_tracker/controllers/semester_plan_controller.dart';
import 'package:aalto_course_tracker/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/add_semester_plan_button.dart';

void main() {
  Get.lazyPut<SemesterPlanController>(() => SemesterPlanController());
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

class HomePage extends StatelessWidget {
  final controller = Get.find<SemesterPlanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Aalto Semester Tracker'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 16.0,
            right: 16.0,
            child: AddSemesterPlanButton(),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "My plans",
                          style: TextStyle(fontSize: 24.0),
                        ),
                        ...List.generate(
                          controller.plans.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: PlanCard(
                              id: controller.plans[index].id,
                              title: controller.plans[index].name,
                              semester: controller.plans[index].semester,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlanPage extends StatelessWidget {
  final String id = Get.parameters['id']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(id),
      ),
      body: Center(
        child: Text('Extract plan data here for $id, from hive storage'),
      ),
    );
  }
}
