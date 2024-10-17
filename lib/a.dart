import 'package:flutter/material.dart';

void main() {
  runApp(SchoolSubjectsApp());
}

class SchoolSubjectsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Subjects',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GradeSelectionScreen(),
    );
  }
}

class GradeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Grade Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrepSchoolScreen()),
                );
              },
              child: Text('الصف الاعدادي'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HighSchoolScreen()),
                );
              },
              child: Text('الصف الثانوي'),
            ),
          ],
        ),
      ),
    );
  }
}

// اعدادي
class PrepSchoolScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الصف'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('الصف الأول الإعدادي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrepSubjectsScreen(grade: 'الصف الأول الإعدادي')),
              );
            },
          ),
          ListTile(
            title: Text('الصف الثاني الإعدادي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrepSubjectsScreen(grade: 'الصف الثاني الإعدادي')),
              );
            },
          ),
          ListTile(
            title: Text('الصف الثالث الإعدادي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrepSubjectsScreen(grade: 'الصف الثالث الإعدادي')),
              );
            },
          ),
        ],
      ),
    );
  }
}
// مواد اعدادي
class PrepSubjectsScreen extends StatelessWidget {
  final String grade;

  PrepSubjectsScreen({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(grade),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الإنجليزية')),
          ListTile(title: Text('اللغة الفرنسية')),
          ListTile(title: Text('الدراسات الاجتماعية')),
          ListTile(title: Text('العلوم')),
          ListTile(title: Text('الرياضيات')),
        ],
      ),
    );
  }
}

// ثانوي
class HighSchoolScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الصف'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('الصف الأول الثانوي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HighSchoolSubjectsScreen(grade: 'الصف الأول الثانوي')),
              );
            },
          ),
          ListTile(
            title: Text('الصف الثاني الثانوي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondGradeStreamScreen()),
              );
            },
          ),
          ListTile(
            title: Text('الصف الثالث الثانوي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThirdGradeStreamScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// اولى ثانوي
class HighSchoolSubjectsScreen extends StatelessWidget {
  final String grade;

  HighSchoolSubjectsScreen({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(grade),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('التاريخ')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('الفلسفة والمنطق')),
          ListTile(title: Text('علوم متكاملة')),
          ListTile(title: Text('الرياضيات')),
        ],
      ),
    );
  }
}

// علمي او ادبي تانيه
class SecondGradeStreamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الشعبة'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('علمي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondGradeSubjectsScreen(stream: 'علمي')),
              );
            },
          ),
          ListTile(
            title: Text('أدبي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondGradeSubjectsScreen(stream: 'أدبي')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// مواد الشعبه نفسها
class SecondGradeSubjectsScreen extends StatelessWidget {
  final String stream;

  SecondGradeSubjectsScreen({required this.stream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواد $stream'),
      ),
      body: ListView(
        children: stream == 'علمي'
            ? [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('الأحياء')),
          ListTile(title: Text('الفيزياء')),
          ListTile(title: Text('الكيمياء')),
          ListTile(title: Text('الرياضيات')),
        ]
            : [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('التاريخ')),
          ListTile(title: Text('الجغرافيا')),
          ListTile(title: Text('علم النفس')),
          ListTile(title: Text('الرياضيات')),
        ],
      ),
    );
  }
}

// شعبه تالته ثانوي
class ThirdGradeStreamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الشعبة'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('علمي علوم'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThirdGradeSubjectsScreen(stream: 'علمي علوم')),
              );
            },
          ),
          ListTile(
            title: Text('علمي رياضه'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThirdGradeSubjectsScreen(stream: 'علمي رياضه')),
              );
            },
          ),
          ListTile(
            title: Text('أدبي'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThirdGradeSubjectsScreen(stream: 'أدبي')),
              );
            },
          ),
        ],
      ),
    );
  }
}

//مواد تالته
class ThirdGradeSubjectsScreen extends StatelessWidget {
  final String stream;

  ThirdGradeSubjectsScreen({required this.stream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواد $stream'),
      ),
      body: ListView(
        children: stream == 'علمي علوم'
            ? [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('الأحياء')),
          ListTile(title: Text('الكيمياء')),
          ListTile(title: Text('الفيزياء')),
        ]
            : stream == 'علمي رياضه'
            ? [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('الرياضيات')),
          ListTile(title: Text('الكيمياء')),
          ListTile(title: Text('الفيزياء')),
        ]
            : [
          ListTile(title: Text('اللغة العربية')),
          ListTile(title: Text('اللغة الأجنبية الأولى')),
          ListTile(title: Text('التاريخ')),
          ListTile(title: Text('الجغرافيا')),
          ListTile(title: Text('الإحصاء')),
        ],
      ),
    );
  }
}