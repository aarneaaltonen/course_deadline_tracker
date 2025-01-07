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
  final String name;
  final String code;
  final List<Deadline> deadlines;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.deadlines,
  });

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'deadlines': deadlines.map((deadline) => deadline.toJson()).toList(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      deadlines: (json['deadlines'] as List)
          .map((deadline) => Deadline.fromJson(deadline))
          .toList(),
    );
  }
}

class Deadline {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Deadline({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }
}
