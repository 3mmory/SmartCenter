import 'package:flutter/material.dart';
import 'student_dashboard.dart'; // استيراد صفحة المدرسين

class SubjectScreen extends StatelessWidget {
  final String gradeName;

  const SubjectScreen({super.key, required this.gradeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gradeName),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          _buildSubjectCard(context, 'Math', 'assets/subjects/math.png', 'math'),
          const SizedBox(height: 10),
          _buildSubjectCard(context, 'Science', 'assets/subjects/physics.jpg', 'science'),
          const SizedBox(height: 10),
          _buildSubjectCard(context, 'English', 'assets/subjects/english.jpeg', 'english'),
          const SizedBox(height: 10),
          _buildSubjectCard(context, 'History', 'assets/subjects/history.jpeg', 'history'),
          const SizedBox(height: 10),
          _buildSubjectCard(context, 'Arabic', 'assets/subjects/arabjpeg.jpeg', 'arabic'),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, String subjectName, String imagePath, String subjectId) {
    return GestureDetector(
      onTap: () {
        if (subjectId.isNotEmpty && subjectName.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDashboard(
                selectedSubject: subjectId,
                subjectName: subjectName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Subject data is missing!')),
          );
        }
      },
      child: SizedBox(
        height: 200, // تحديد ارتفاع ثابت للبطاقات
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Stack(
            children: [
              // صورة المادة كخلفية داكنة
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.1), // جعل الصورة داكنة
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              // النص في الأسفل
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // خلفية سوداء شفافة
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    subjectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
