class SemesterPlan {
  final String id;
  final String name;
  final String semester;
  final List<Course> courses;

  SemesterPlan({
    required this.id,
    required this.name,
    required this.semester,
    required this.courses,
  });

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory SemesterPlan.fromJson(Map<String, dynamic> json) {
    return SemesterPlan(
      id: json['id'],
      name: json['name'],
      semester: json['semester'],
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    );
  }
}

class Course {
  final String id;
  final String semesterPlanId;
  final String name;
  final int color;
  final String? code;
  final List<Deadline> deadlines;

  Course({
    required this.id,
    required this.semesterPlanId,
    required this.name,
    this.color = 0xFF93CEFF, // Light blue color
    this.code,
    required this.deadlines,
  });

  Map toJson() {
    return {
      'id': id,
      'semesterPlanId': semesterPlanId,
      'color': color,
      'name': name,
      'code': code,
      'deadlines': deadlines.map((deadline) => deadline.toJson()).toList(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      semesterPlanId: json['semesterPlanId'],
      name: json['name'],
      color: json['color'],
      code: json['code'],
      deadlines: (json['deadlines'] as List)
          .map((deadline) => Deadline.fromJson(deadline))
          .toList(),
    );
  }
}

class Deadline {
  final String id;
  final String courseId;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Deadline({
    required this.id,
    required this.courseId,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'],
      courseId: json['courseId'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }
}
