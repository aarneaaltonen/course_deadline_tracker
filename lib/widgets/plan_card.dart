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
        child: Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(semester),
          ),
        ),
      ),
    );
  }
}
