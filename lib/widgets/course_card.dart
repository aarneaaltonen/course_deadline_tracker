import 'package:flutter/material.dart';
import '../models/models.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final courseColor = Color(int.parse(course.color));

    return Card(
      color: courseColor,
      child: Row(
        children: [
          Container(
            width: 300,
            color: courseColor, // Colored part on the left
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color:
                  Colors.grey[200], // Gray background for the rest of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name),
                    Text('ID: ${course.id}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
