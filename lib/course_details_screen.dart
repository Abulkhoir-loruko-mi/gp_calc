import 'package:flutter/material.dart';
import 'package:gp_calc/settings_screen.dart';

import 'models.dart';

class CourseDetailsScreen extends StatelessWidget {
  final List<SemesterData> semesters;
  final double overallCGPA;

  const CourseDetailsScreen({
    Key? key,
    required this.semesters,
    required this.overallCGPA,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A90E2)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Course Details',
            style: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download, color: Color(0xFF4A90E2)),
              onPressed: () => _exportToPDF(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                children: [
                // Summary Header
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
                padding: const EdgeInsets.all(20),
                child: Column(
                    children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    _buildSummaryItem('Overall CGPA', overallCGPA.toStringAsFixed(2)),
                _buildSummaryItem('Semesters', '${semesters.length}'),
               // _buildSummary
                      _buildSummaryItem('Total Credits', '${_getTotalCredits()}'),
                    ],
                    ),
                      const SizedBox(height: 12),
                      Text(
                        'Based on ${GradeScaleManager.getScaleLabel()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                ),
                ),

                  const SizedBox(height: 24),

                  // Semester-wise Course Details
                  ...semesters.asMap().entries.map((entry) {
                    int semesterIndex = entry.key;
                    SemesterData semester = entry.value;
                    return _buildSemesterDetails(semesterIndex + 1, semester);
                  }).toList(),

                  const SizedBox(height: 20),

                  // Overall Statistics
                  _buildOverallStatistics(),

                  const SizedBox(height: 40),
                ],
            ),
        ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterDetails(int semesterNumber, SemesterData semester) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semester $semesterNumber',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${semester.courses.length} courses • ${semester.totalCredits} credits',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getGPAColor(semester.gpa),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'GPA: ${semester.gpa.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Course Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Course', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                Expanded(flex: 1, child: Text('Units', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('Grade', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('GP', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('Points', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center)),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: const Color(0xFFE8E8E8),
          ),

          // Course Rows
          ...semester.courses.map((course) => _buildCourseRow(course)).toList(),

          // Semester Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semester Total:',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${semester.totalCredits} Credits  •  ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      '${_calculateSemesterPoints(semester).toStringAsFixed(1)} Points',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow(Course course) {
    double gradePoints = GradeScaleManager.getGradePoints(course.grade);
    double totalPoints = gradePoints * course.units;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Course Name
          Expanded(
            flex: 3,
            child: Text(
              course.name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1D1D1F),
              ),
            ),
          ),

          // Units
          Expanded(
            flex: 1,
            child: Text(
              '${course.units}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Grade
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getGradeColor(course.grade).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course.grade,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getGradeColor(course.grade),
                  ),
                ),
              ),
            ),
          ),

          // Grade Points
          Expanded(
            flex: 1,
            child: Text(
              gradePoints.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A90E2),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Total Points
          Expanded(
            flex: 1,
            child: Text(
              totalPoints.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF34C759),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatistics() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Overall Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 10), // Changed from 20 to 10

          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Total Courses', '${_getTotalCourses()}', '📚'),
              _buildStatCard('Total Credits', '${_getTotalCredits()}', '🎯'),
              _buildStatCard('Highest GPA', '${_getHighestGPA().toStringAsFixed(2)}', '⭐'),
              _buildStatCard('Average GPA', '${_getAverageGPA().toStringAsFixed(2)}', '📈'),
            ],
          ),

          const SizedBox(height: 10), // This was previously changed

          // Grade Distribution
          
          const Text(
            'Grade Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 4), // This was previously changed

          ..._buildGradeDistribution(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGradeDistribution() {
    Map<String, int> gradeCount = {};
    int totalCourses = _getTotalCourses();

    // Count grades
    for (var semester in semesters) {
      for (var course in semester.courses) {
        gradeCount[course.grade] = (gradeCount[course.grade] ?? 0) + 1;
      }
    }

    // Sort by grade points (highest first)
    var sortedGrades = gradeCount.entries.toList();
    sortedGrades.sort((a, b) =>
        GradeScaleManager.getGradePoints(b.key).compareTo(
            GradeScaleManager.getGradePoints(a.key)));

    return sortedGrades.map((entry) {
      String grade = entry.key;
      int count = entry.value;
      double percentage = (count / totalCourses) * 100;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getGradeColor(grade),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getGradeColor(grade),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Helper Methods
  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return const Color(0xFF34C759);
    if (gpa >= 3.0) return const Color(0xFF4A90E2);
    if (gpa >= 2.5) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  Color _getGradeColor(String grade) {
    double points = GradeScaleManager.getGradePoints(grade);
    double maxPoints = GradeScaleManager.getMaxPoints();
    double percentage = points / maxPoints;

    if (percentage >= 0.85) return const Color(0xFF34C759);
    if (percentage >= 0.70) return const Color(0xFF4A90E2);
    if (percentage >= 0.50) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  int _getTotalCredits() {
    return semesters.fold(0, (sum, semester) => sum + semester.totalCredits);
  }

  int _getTotalCourses() {
    return semesters.fold(0, (sum, semester) => sum + semester.courses.length);
  }

  double _getHighestGPA() {
    return semesters.map((s) => s.gpa).reduce((a, b) => a > b ? a : b);
  }

  double _getAverageGPA() {
    double sum = semesters.fold(0.0, (sum, semester) => sum + semester.gpa);
    return sum / semesters.length;
  }

  double _calculateSemesterPoints(SemesterData semester) {
    return semester.courses.fold(0.0, (sum, course) =>
    sum + (GradeScaleManager.getGradePoints(course.grade) * course.units));
  }

  void _exportToPDF(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export functionality coming soon!'),
        backgroundColor: Color(0xFF4A90E2),
      ),
    );
  }
}
