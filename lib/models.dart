

class Course {
  String name;
  int units;
  String grade;

  Course({
    required this.name, required this.units, required this.grade,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'units': units,
      'grade': grade,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      units: json['units'],
      grade: json['grade'],
    );
  }
}

class SemesterData {
  final List<Course> courses;
  final double gpa;
  final int totalCredits;

  SemesterData({
    required this.courses,
    required this.gpa,
    required this.totalCredits,
  });
  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((course) => course.toJson()).toList(),
      'gpa': gpa,
      'totalCredits': totalCredits,
    };
  }

  factory SemesterData.fromJson(Map<String, dynamic> json) {
    return SemesterData(
      courses: (json['courses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
      gpa: json['gpa'].toDouble(),
      totalCredits: json['totalCredits'],
    );
  }

}

