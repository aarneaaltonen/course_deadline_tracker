import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/semester_plan_controller.dart';
import '../widgets/add_semester_plan_button.dart';
import '../widgets/plan_card.dart';

class HomePage extends StatelessWidget {
  final controller = Get.find<SemesterPlanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Course Deadline Tracker'),
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
                        if (controller.plans.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "No plans yet",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                controller.plans.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PlanCard(
                                    id: controller.plans[index].id,
                                    title: controller.plans[index].name,
                                    semester: controller.plans[index].semester,
                                  ),
                                ),
                              ),
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
