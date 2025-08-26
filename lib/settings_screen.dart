import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedGradeScale = '4.0';
  bool isDarkMode = false;
  bool showNotifications = true;
  bool autoSave = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGradeScale = prefs.getString('gradeScale') ?? '4.0';
      isDarkMode = prefs.getBool('darkMode') ?? false;
      showNotifications = prefs.getBool('notifications') ?? true;
      autoSave = prefs.getBool('autoSave') ?? true;
    });

    // Set the global grade scale
    GradeScaleManager.setScale(selectedGradeScale);
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gradeScale', selectedGradeScale);
    await prefs.setBool('darkMode', isDarkMode);
    await prefs.setBool('notifications', showNotifications);
    await prefs.setBool('autoSave', autoSave);

    // Update the global grade scale
    GradeScaleManager.setScale(selectedGradeScale);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Color(0xFF34C759),
      ),
    );
  }

  Widget _buildGradeScaleOption(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        _getScaleDescription(value),
        style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: selectedGradeScale,
        onChanged: (String? newValue) {
          setState(() {
            selectedGradeScale = newValue!;
          });
          _saveSettings();
        },
        activeColor: const Color(0xFF4A90E2),
      ),
    );
  }

  String _getScaleDescription(String scale) {
    switch (scale) {
      case '4.0': return 'Most common in US universities';
      case '5.0': return 'Used in some institutions';
      case '10.0': return 'Common in Indian universities';
      default: return '';
    }
  }

  Widget _buildGradeReference(String grade, String points, String percentage) {
    // Update to show current scale points
    String currentPoints = GradeScaleManager.getGradePoints(grade).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            grade,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          Text(
            currentPoints,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A90E2),
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'oladejisoliu@gmail.com',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle error: could not launch email app
      // You could show a SnackBar or an AlertDialog here

     // print('Could not launch email app');
    }
  }

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
          'Settings',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grade Scale Section
            _buildSectionCard(
              title: '📊 Grade Scale',
              child: Column(
                children: [
                  _buildGradeScaleOption('4.0 Point Scale', '4.0'),
                  const Divider(height: 1),
                  _buildGradeScaleOption('5.0 Point Scale', '5.0'),
                  const Divider(height: 1),
                  _buildGradeScaleOption('10.0 Point Scale', '10.0'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // App Preferences Section
            _buildSectionCard(
              title: '⚙️ App Preferences',
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme',
                    icon: '🌙',
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Notifications',
                    subtitle: 'Get reminders and updates',
                    icon: '🔔',
                    value: showNotifications,
                    onChanged: (value) {
                      setState(() {
                        showNotifications = value;
                      });
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Auto Save',
                    subtitle: 'Automatically save calculations',
                    icon: '💾',
                    value: autoSave,
                    onChanged: (value) {
                      setState(() {
                        autoSave = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Grade Scale Reference
            _buildSectionCard(
              title: '📚 Grade Scale Reference',
              child: Column(
                children: [
                  _buildGradeReference('A+', '4.0', '90-100%'),
                  _buildGradeReference('A', '4.0', '85-89%'),
                  _buildGradeReference('A-', '3.7', '80-84%'),
                  _buildGradeReference('B+', '3.3', '77-79%'),
                  _buildGradeReference('B', '3.0', '73-76%'),
                  _buildGradeReference('B-', '2.7', '70-72%'),
                  _buildGradeReference('C+', '2.3', '67-69%'),
                  _buildGradeReference('C', '2.0', '63-66%'),
                  _buildGradeReference('C-', '1.7', '60-62%'),
                  _buildGradeReference('D', '1.0', '50-59%'),
                  _buildGradeReference('F', '0.0', '0-49%'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About Section
            _buildSectionCard(
              title: 'ℹ️ About',
              child: Column(
                children: [
                  _buildInfoTile('Version', '1.0.0'),
                  const Divider(height: 1),
                  _buildInfoTile('Developer', 'Oladeji Sooliu Ayantunji(Abulkhoir)'),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Contact Support',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _launchEmail, // Updated onTap to call _launchEmail
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1F),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: child,
          ),
        ],
      ),
    );
  }

  /*Widget _buildGradeScaleOption(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: selectedGradeScale,
        onChanged: (String? newValue) {
          setState(() {
            selectedGradeScale = newValue!;
          });
          _saveSettings();
        },
        activeColor: const Color(0xFF4A90E2),
      ),
    );
  }
*/
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4A90E2),
      ),
    );
  }

 /* Widget _buildGradeReference(String grade, String points, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            grade,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A90E2),
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
      ),
    );
  }


}

class GradeScaleManager {
  static String _currentScale = '5.0';

  static String get currentScale => _currentScale;

  static void setScale(String scale) {
    _currentScale = scale;
  }

  static double getGradePoints(String grade) {
    switch (_currentScale) {
      case '4.0':
        return _getGradePoints4Point(grade);
      case '5.0':
        return _getGradePoints5Point(grade);
      case '10.0':
        return _getGradePoints10Point(grade);
      default:
        return _getGradePoints4Point(grade);
    }
  }

  static double _getGradePoints4Point(String grade) {
    switch (grade) {
      case 'A+': case 'A': return 4.0;
      case 'A-': return 3.7;
      case 'B+': return 3.3;
      case 'B': return 3.0;
      case 'B-': return 2.7;
      case 'C+': return 2.3;
      case 'C': return 2.0;
      case 'C-': return 1.7;
      case 'D': return 1.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  static double _getGradePoints5Point(String grade) {
    switch (grade) {
      case 'A+': case 'A': return 5.0;
      case 'A-': return 4.5;
      case 'B+': return 4.0;
      case 'B': return 3.5;
      case 'B-': return 3.0;
      case 'C+': return 2.5;
      case 'C': return 2.0;
      case 'C-': return 1.5;
      case 'D': return 1.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  static double _getGradePoints10Point(String grade) {
    switch (grade) {
      case 'A+': return 10.0;
      case 'A': return 9.0;
      case 'A-': return 8.5;
      case 'B+': return 8.0;
      case 'B': return 7.0;
      case 'B-': return 6.5;
      case 'C+': return 6.0;
      case 'C': return 5.0;
      case 'C-': return 4.5;
      case 'D': return 4.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  static String getScaleLabel() {
    return '$_currentScale Point Scale';
  }

  static double getMaxPoints() {
    switch (_currentScale) {
      case '4.0': return 4.0;
      case '5.0': return 5.0;
      case '10.0': return 10.0;
      default: return 4.0;
    }
  }
}
