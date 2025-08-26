import 'package:flutter/material.dart';

import 'course_input_screen.dart';

class SemesterInputScreen extends StatefulWidget {
  const SemesterInputScreen({Key? key}) : super(key: key);

  @override
  _SemesterInputScreenState createState() => _SemesterInputScreenState();
}

class _SemesterInputScreenState extends State<SemesterInputScreen> {
  int selectedSemesters = 4;

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
          'CGPA Calculator',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Question
            const Text(
              'How many semesters are you calculating?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1F),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              '(Including current semester)',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 60),

            // Number Display with +/- buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Button
                GestureDetector(
                  onTap: () {
                    if (selectedSemesters > 1) {
                      setState(() {
                        selectedSemesters--;
                      });
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedSemesters > 1 ? const Color(0xFF4A90E2) : const Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: selectedSemesters > 1 ? Colors.white : const Color(0xFF999999),
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 40),

                // Number Display
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$selectedSemesters',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 40),

                // Plus Button
                GestureDetector(
                  onTap: () {
                    if (selectedSemesters < 12) {
                      setState(() {
                        selectedSemesters++;
                      });
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedSemesters < 12 ? const Color(0xFF4A90E2) : const Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: selectedSemesters < 12 ? Colors.white : const Color(0xFF999999),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'semesters',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),

            const Spacer(),

            // Continue Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseInputScreen(
                        currentSemester: 1,
                        totalSemesters: selectedSemesters,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}