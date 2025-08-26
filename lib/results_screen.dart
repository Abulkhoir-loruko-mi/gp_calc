import 'package:flutter/material.dart';
import 'package:gp_calc/settings_screen.dart';

import 'course_details_screen.dart';
import 'home_screen.dart';
import 'models.dart';

class ResultsScreen extends StatelessWidget {
  final List<SemesterData> semesters;
  final double overallCGPA;

  const ResultsScreen({
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
        automaticallyImplyLeading: false, // Add this line
        title: const Text(
          'Your Results',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF4A90E2)),
            onPressed: _shareResults,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Main CGPA Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Overall CGPA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    overallCGPA.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getGradeCategory(overallCGPA),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
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

            const SizedBox(height: 30),

            // Semester Breakdown
            Container(
              width: double.infinity,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Semester Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...semesters.asMap().entries.map((entry) {
                    int index = entry.key;
                    SemesterData semester = entry.value;
                    return _buildSemesterCard(index + 1, semester);
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Summary Stats
            Container(
              width: double.infinity,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📈 Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Total Credits',
                          '${_getTotalCredits()}',
                          const Color(0xFF34C759),
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Semesters',
                          '${semesters.length}',
                          const Color(0xFF4A90E2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Highest GPA',
                          '${_getHighestGPA().toStringAsFixed(2)}',
                          const Color(0xFFFF9500),
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Average GPA',
                          '${_getAverageGPA().toStringAsFixed(2)}',
                          const Color(0xFF5AC8FA),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            // In the action buttons section of ResultsScreen
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsScreen(
                          semesters: semesters,
                          overallCGPA: overallCGPA,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '📋 View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ... other existing buttons


                /*Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveToHistory(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34C759),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '💾 Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),*/
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _calculateAgain(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '🔄 Calculate Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterCard(int semesterNumber, SemesterData semester) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
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
                  fontSize: 16,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getGPAColor(semester.gpa).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              semester.gpa.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getGPAColor(semester.gpa),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  String _getGradeCategory(double cgpa) {
    if (cgpa >= 3.7) return 'Excellent';
    if (cgpa >= 3.3) return 'Very Good';
    if (cgpa >= 3.0) return 'Good';
    if (cgpa >= 2.7) return 'Satisfactory';
    if (cgpa >= 2.0) return 'Pass';
    return 'Below Average';
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return const Color(0xFF34C759);
    if (gpa >= 3.0) return const Color(0xFF4A90E2);
    if (gpa >= 2.5) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  int _getTotalCredits() {
    return semesters.fold(0, (sum, semester) => sum + semester.totalCredits);
  }

  double _getHighestGPA() {
    if (semesters.isEmpty) return 0.0; // Add check for empty list
    return semesters.map((s) => s.gpa).reduce((a, b) => a > b ? a : b);
  }

  double _getAverageGPA() {
    if (semesters.isEmpty) return 0.0; // Add check for empty list
    double sum = semesters.fold(0.0, (sum, semester) => sum + semester.gpa);
    return sum / semesters.length;
  }

  void _shareResults() {
    // Implement share functionality
  }

  void _saveToHistory(BuildContext context) {
    // Save to local storage/database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results saved to history!'),
        backgroundColor: Color(0xFF34C759),
      ),
    );
  }

  void _calculateAgain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
    );
  }
}

// Data Models
