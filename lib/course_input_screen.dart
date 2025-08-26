import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gp_calc/results_screen.dart';
import 'package:gp_calc/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_screen.dart';
import 'package:gp_calc/models.dart' as model;

class CourseInputScreen extends StatefulWidget {
  final int currentSemester;
  final int totalSemesters;

  const CourseInputScreen({
    Key? key,
    required this.currentSemester,
    required this.totalSemesters,
  }) : super(key: key);

  @override
  _CourseInputScreenState createState() => _CourseInputScreenState();
}

class _CourseInputScreenState extends State<CourseInputScreen> {
  Future<void> _saveToHistory({
    required double cgpa,
    required int totalSemesters,
    required int totalCredits,
    required List<model.SemesterData> semesterDetails,
  }) async {
    try {
      final historyItem = CalculationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cgpa: cgpa,
        semesters: totalSemesters,
        totalCredits: totalCredits,
        date: DateTime.now(),
        semesterDetails: semesterDetails,
      );

      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('calculation_history') ?? [];

      // Add new calculation at the beginning
      historyJson.insert(0, jsonEncode(historyItem.toJson()));

      // Keep only last 50 calculations
      if (historyJson.length > 50) {
        historyJson.removeRange(50, historyJson.length);
      }

      await prefs.setStringList('calculation_history', historyJson);
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  List<model.Course> courses = [
    model.Course(name: 'Chemistry 101', units: 3, grade: 'A'),
    model.Course(name: 'Physics Lab', units: 1, grade: 'B'),
  ];

 /* double get currentGPA {
    if (courses.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      totalPoints += _getGradePoints(course.grade) * course.units;
      totalCredits += course.units;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }*/

  double _getGradePoints(String grade) {
    switch (grade) {
      case 'A': return 5.0;
      case 'B': return 4.0;
      case 'C': return 3.0;
      case 'D': return 2.0;
      case 'E': return 1.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF4A90E2), size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'Semester ${widget.currentSemester} of ${widget.totalSemesters}',
                          style: const TextStyle(
                            color: Color(0xFF4A90E2),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(widget.totalSemesters, (index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < widget.currentSemester
                              ? const Color(0xFF4A90E2)
                              : const Color(0xFFE0E0E0),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Intro Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: const Column(
                        children: [
                          Text('📖', style: TextStyle(fontSize: 24)),
                          SizedBox(height: 8),
                          Text(
                            'Add Your Courses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Enter course details for accurate CGPA calculation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Course Cards
                    ...courses.asMap().entries.map((entry) {
                      int index = entry.key;
                      model.Course course = entry.value;
                      return _buildCourseCard(course, index);
                    }).toList(),

                    // Add Course Button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _addCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34C759),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('➕', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text(
                              'Add Course',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Actions
                    Row(
                      children: [
                        // Preview Card
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '📊 Current GPA',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentGPA.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF34C759),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Next Button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: courses.isNotEmpty ? _nextSemester : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.currentSemester == widget.totalSemesters
                                  ? 'Calculate CGPA ➜'
                                  : 'Next Semester ➜',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(model.Course course, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Course Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Course ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                GestureDetector(
                  onTap: () => _deleteCourse(index),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Course Name Input
            TextFormField(
              initialValue: course.name,
              onChanged: (value) {
                setState(() {
                  courses[index].name = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Course Name (e.g., Math 101)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 16),

            // Credits and Grade Row
            Row(
              children: [
                // Credits Dropdown
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: course.units,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: [1, 2, 3, 4, 5, 6].map((credits) {
                      return DropdownMenuItem(
                        value: credits,
                        child: Text('$credits Units'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        courses[index].units = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Grade Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: course.grade,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: [ 'A',  'B',  'C', 'D','E',  'F']
                        .map((grade) {
                      return DropdownMenuItem(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        courses[index].grade = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addCourse() {
    setState(() {
      courses.add(model.Course(name: '', units: 3, grade: 'A'));
    });
  }

  void _deleteCourse(int index) {
    if (courses.length > 1) {
      setState(() {
        courses.removeAt(index);
      });
    }
  }

  void _nextSemester() {
    // Save current semester data
    model.SemesterData currentSemesterData = model.SemesterData(
      courses: List<model.Course>.from(courses), // Ensure it's a list of model.Course
      gpa: currentGPA,
      totalCredits: courses.fold(0, (sum, course) => sum + course.units),
    );

    CGPACalculator.addSemester(currentSemesterData);

    if (widget.currentSemester == widget.totalSemesters) {
      // Calculate final CGPA
      final overallCGPA = CGPACalculator.calculateOverallCGPA();
      final totalCredits = CGPACalculator.allSemesters
          .fold(0, (sum, semester) => sum + semester.totalCredits);

      _saveToHistory(
        cgpa: overallCGPA,
        totalSemesters: widget.totalSemesters,
        totalCredits: totalCredits,
        semesterDetails: CGPACalculator.allSemesters,
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            semesters: CGPACalculator.allSemesters,
            overallCGPA: CGPACalculator.calculateOverallCGPA(),
          ),
        ),
      );
    } else {
      // Navigate to next semester
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CourseInputScreen(
            currentSemester: widget.currentSemester + 1,
            totalSemesters: widget.totalSemesters,
          ),
        ),
      );
    }
  }
  double get currentGPA {
    if (courses.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      totalPoints += GradeScaleManager.getGradePoints(course.grade) * course.units;
      totalCredits += course.units;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }
}

class CGPACalculator {
  static List<model.SemesterData> allSemesters = [];

  static void addSemester(model.SemesterData semester) {
    allSemesters.add(semester);
  }

  static void clearData() {
    allSemesters.clear();
  }

  static double calculateOverallCGPA() {
    if (allSemesters.isEmpty) return 0.0;

    double totalPoints = 0;
    int totalCredits = 0;

    for (var semester in allSemesters) {
      for (var course in semester.courses) {
        totalPoints += GradeScaleManager.getGradePoints(course.grade) * course.units;
       // totalPoints += _getGradePoints(course.grade) * course.units;
        totalCredits += course.units;
      }
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  static double _getGradePoints(String grade) {
    switch (grade) {
      case 'A': return 5.0;
      case 'B': return 4.0;
      case 'C': return 3.0;
      case 'D': return 2.0;
      case 'E': return 1.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }
}
