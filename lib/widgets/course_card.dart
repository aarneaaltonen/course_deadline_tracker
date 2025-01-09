import 'package:aalto_course_tracker/controllers/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/models.dart';
import 'add_deadline_button.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard({required this.course});

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isPressed = false;
  final controller = Get.find<CourseController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(widget.course.name),
              content: Text('Details about the course: ${widget.course.name}'),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Card(
        color: Color(widget.course.color),
        shape: _isPressed
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
        child: SizedBox(
          width: (size.width < BreakPoints.small)
              ? 120
              : (size.width < BreakPoints.medium)
                  ? 150
                  : AppConstants.courseCardWidth,
          height: 80,
          child: InkWell(
            hoverColor: Colors.blue.withValues(alpha: 0.2),
            highlightColor: Colors.blue.withValues(alpha: 0.2),
            splashColor: Colors.blue.withValues(alpha: 0.1),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Text(widget.course.name),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete Course',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Course'),
                                    content: Text(
                                        'Are you sure you want to delete this course?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          controller
                                              .deleteCourse(widget.course.id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                        Expanded(child: Container()),
                        AddDeadlineButton(courseId: widget.course.id),
                      ],
                    ),
                    content: CourseDialogContent(course: widget.course),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.course.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(child: Container()),
                  if (size.width > BreakPoints.small)
                    AddDeadlineButton(courseId: widget.course.id),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CourseDialogContent extends StatefulWidget {
  final Course course;

  const CourseDialogContent({
    required this.course,
  });

  @override
  _CourseDialogContentState createState() => _CourseDialogContentState();
}

class _CourseDialogContentState extends State<CourseDialogContent> {
  final controller = Get.find<CourseController>();
  Color _selectedColor = Colors.white;

  void _updateCourse() {
    final updatedCourse = Course(
      id: widget.course.id,
      name: widget.course.name,
      semesterPlanId: widget.course.semesterPlanId,
      deadlines: widget.course.deadlines,
      color: _selectedColor.value,
    );

    controller.updateCourse(updatedCourse);
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = Color(widget.course.color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildColorOption(const Color.fromARGB(255, 254, 156, 149)),
            _buildColorOption(const Color.fromARGB(255, 149, 252, 153)),
            _buildColorOption(const Color.fromARGB(255, 147, 206, 255)),
            _buildColorOption(const Color.fromARGB(255, 232, 222, 131)),
            _buildColorOption(const Color.fromARGB(255, 230, 143, 245)),
            _buildColorOption(const Color.fromARGB(255, 245, 184, 143)),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _updateCourse();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: _selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
