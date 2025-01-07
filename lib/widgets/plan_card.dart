import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                ListTile(
                  title: Text(title),
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

  const PlanPopover({Key? key, required this.id}) : super(key: key);

  void _deletePlan() {
    // TODO: Implement plan deletion
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _deletePlan();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8.0),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ];
      },
      icon: Icon(Icons.settings, color: Colors.grey),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 5,
    );
  }
}
