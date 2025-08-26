import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:gp_calc/models.dart' as model;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('calculation_history') ?? [];

    setState(() {
      historyList = historyJson
          .map((json) => CalculationHistory.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = historyList
        .map((history) => jsonEncode(history.toJson()))
        .toList();

    await prefs.setStringList('calculation_history', historyJson);
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  List<CalculationHistory> historyList = [
    CalculationHistory(
      id: '1',
      cgpa: 3.67,
      semesters: 4,
      totalCredits: 120,
      date: DateTime.now().subtract(const Duration(days: 1)),
      // Example: semesterDetails would be List<model.SemesterData>
    ),
    /*alculationHistory(
      id: '2',
      cgpa: 3.45,
      semesters: 3,
      totalCredits: 90,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    CalculationHistory(
      id: '3',
      cgpa: 3.23,
      semesters: 2,
      totalCredits: 60,
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),*/
  ];

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
          'Calculation History',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF666666)),
            onPressed: _showClearAllDialog,
          ),
        ],
      ),
      body: historyList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(historyList[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📊', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          const Text(
            'No Calculations Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your CGPA calculations will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to calculate CGPA
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Calculate CGPA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(CalculationHistory history, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _viewDetails(history),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // CGPA Circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getGPAColor(history.cgpa).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      history.cgpa.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getGPAColor(history.cgpa),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(history.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${history.semesters} semesters • ${history.totalCredits} credits',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getGPAColor(history.cgpa).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getGradeCategory(history.cgpa),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getGPAColor(history.cgpa),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF666666)),
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        _viewDetails(history);
                        break;
                      case 'share':
                        _shareResult(history);
                        break;
                      case 'delete':
                        _deleteHistory(index);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View Details'),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Text('Share'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return const Color(0xFF34C759);
    if (gpa >= 3.0) return const Color(0xFF4A90E2);
    if (gpa >= 2.5) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  String _getGradeCategory(double cgpa) {
    if (cgpa >= 3.7) return 'Excellent';
    if (cgpa >= 3.3) return 'Very Good';
    if (cgpa >= 3.0) return 'Good';
    if (cgpa >= 2.7) return 'Satisfactory';
    return 'Pass';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference} days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _viewDetails(CalculationHistory history) {
    // Navigate to detailed view or show bottom sheet
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDetailsBottomSheet(history),
    );
  }

  Widget _buildDetailsBottomSheet(CalculationHistory history) {
    // TODO: If semesterDetails are to be displayed, update this to use history.semesterDetails which is List<model.SemesterData>?
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'CGPA Details',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem('CGPA', history.cgpa.toStringAsFixed(2)),
              _buildDetailItem('Semesters', '${history.semesters}'),
              _buildDetailItem('Credits', '${history.totalCredits}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Calculated on ${_formatDate(history.date)}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
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

  void _shareResult(CalculationHistory history) {
    final shareText = '''
📊 My CGPA Result

CGPA: ${history.cgpa.toStringAsFixed(2)}
Grade: ${_getGradeCategory(history.cgpa)}
Semesters: ${history.semesters}
Total Credits: ${history.totalCredits}

Calculated on: ${_formatDate(history.date)}

#CGPA #GPA #AcademicResults
  ''';

    Share.share(shareText);
  }

  static Future<void> addCalculationToHistory(CalculationHistory newCalculation) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('calculation_history') ?? [];

    // Add new calculation at the beginning
    historyJson.insert(0, jsonEncode(newCalculation.toJson()));

    // Keep only last 50 calculations to prevent storage bloat
    if (historyJson.length > 50) {
      historyJson.removeRange(50, historyJson.length);
    }

    await prefs.setStringList('calculation_history', historyJson);
  }

  void _deleteHistory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Calculation'),
        content: const Text('Are you sure you want to delete this calculation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                historyList.removeAt(index);
              });
              await _saveHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calculation deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to delete all calculations?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                historyList.clear();
              });
              await _saveHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All history cleared')),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class CalculationHistory {
  final String id;
  final double cgpa;
  final int semesters;
  final int totalCredits;
  final DateTime date;
  final List<model.SemesterData>? semesterDetails; // Use model.SemesterData

  CalculationHistory({
    required this.id,
    required this.cgpa,
    required this.semesters,
    required this.totalCredits,
    required this.date,
    this.semesterDetails,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cgpa': cgpa,
      'semesters': semesters,
      'totalCredits': totalCredits,
      'date': date.toIso8601String(),
      'semesterDetails': semesterDetails?.map((s) => s.toJson()).toList(),
    };
  }

  // Create from JSON
  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      id: json['id'],
      cgpa: json['cgpa'].toDouble(),
      semesters: json['semesters'],
      totalCredits: json['totalCredits'],
      date: DateTime.parse(json['date']),
      semesterDetails: json['semesterDetails'] != null
          ? (json['semesterDetails'] as List)
          .map((s) => model.SemesterData.fromJson(s as Map<String, dynamic>)) // Use model.SemesterData
          .toList()
          : null,
    );
  }
}

// Removed local SemesterData and CourseGrade classes to use the ones from models.dart via 'model.' prefix
