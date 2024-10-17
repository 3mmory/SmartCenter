import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'StageDetailsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditProfilePage.dart';
import 'StudentTeachersPage.dart';
import 'PricingScreen.dart';

class HomeScreen extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String phone; // إضافة حقل رقم الهاتف

  const HomeScreen({super.key, required this.studentName, required this.studentId, required this.phone}); // إضافة الهاتف كمدخل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Center',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(studentName),
              accountEmail: Text(phone), // عرض رقم الهاتف
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  studentName[0],
                  style: const TextStyle(fontSize: 40.0, color: Colors.lightBlueAccent),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.lightBlueAccent),
              title: Text('Edit Profile'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.lightBlueAccent),
              title: Text('Registered Teachers'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentTeachersPage(studentId: studentId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.lightBlueAccent),
              title: Text('Price list'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PricingScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome, ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.indigoAccent.shade700, // لون "Welcome"
                    ),
                  ),
                  TextSpan(
                    text: studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.redAccent, // لون اسم الطالب المختلف
                    ),
                  ),
                  TextSpan(
                    text: ' !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.indigoAccent.shade700, // لون علامة التعجب "!"
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStageCard(
                    label: 'المرحلة الإعدادية',
                    color: Colors.lightBlue,
                    icon: FontAwesomeIcons.school,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StageDetailsScreen(stageName: 'المرحلة الإعدادية'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildStageCard(
                    label: 'المرحلة الثانوية',
                    color: Colors.lightBlue,
                    icon: FontAwesomeIcons.graduationCap,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StageDetailsScreen(stageName: 'المرحلة الثانوية'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: Colors.black38,
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 70,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
