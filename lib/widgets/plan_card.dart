import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/semester_plan_controller.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String semester;
  final String id;

  const PlanCard(
      {Key? key, required this.title, required this.semester, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 150,
      child: InkWell(
        onTap: () {
          Get.toNamed('/plan/$id');
        },
        borderRadius: BorderRadius.circular(15.0),
        splashColor: Colors.blue.withAlpha(30),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        const Color.fromARGB(255, 82, 82, 82),
                        const Color.fromARGB(255, 53, 38, 56)
                      ]
                    : [Colors.white, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                ListTile(
                  title: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(semester),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: PlanPopover(id: id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanPopover extends StatelessWidget {
  final String id;
  final controller = Get.find<SemesterPlanController>();

  PlanPopover({Key? key, required this.id}) : super(key: key);

  void _deletePlan() {
    controller.deletePlan(id);
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Plan'),
          content: Text('Are you sure you want to delete this plan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePlan();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmationDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 8.0),
                Text('Delete plan'),
              ],
            ),
          ),
        ];
      },
    );
  }
}
