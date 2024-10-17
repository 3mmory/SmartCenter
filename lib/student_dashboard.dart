import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_9_18/pricingscreen.dart';

import 'EditProfilePage.dart';
import 'StudentTeachersPage.dart';

class StudentDashboard extends StatefulWidget {
  final String selectedSubject; // المادة المختارة
  final String subjectName; // اسم المادة

  StudentDashboard({required this.selectedSubject, required this.subjectName});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  User? user;
  String studentName = 'Student Name';
  String studentPhone = 'Phone Number';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadStudentData(); // تحميل البيانات عند فتح التطبيق
  }

  Future<void> loadStudentData() async {
    if (user != null) {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(user!.uid)
          .get();
      setState(() {
        studentName = studentSnapshot['firstName'] + ' ' + studentSnapshot['lastName'];
        studentPhone = studentSnapshot['phone'];
      });
    }
  }

  void bookLesson(String teacherId) async {
    try {
      if (user != null) {
        DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection('students')
            .doc(user!.uid)
            .get();

        if (!studentSnapshot.exists || studentSnapshot['bookedTeachers'] == null) {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(user!.uid)
              .set({
            'bookedTeachers': [],
            'firstName': '...',
            'lastName': '...',
            'phone': '...',
          }, SetOptions(merge: true));
        }

        List<dynamic> bookedTeachers = studentSnapshot['bookedTeachers'] ?? [];

        if (bookedTeachers.contains(teacherId)) {
          showErrorDialog("You've already booked this teacher.");
          return;
        }

        if (bookedTeachers.length >= 6) {
          showErrorDialog("You can't book more than 6 teachers.");
          return;
        }

        await FirebaseFirestore.instance
            .collection('students')
            .doc(user!.uid)
            .update({
          'bookedTeachers': FieldValue.arrayUnion([teacherId]),
        });

        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .update({
          'students': FieldValue.arrayUnion([{
            'studentId': user!.uid,
            'name': studentSnapshot['firstName'] + ' ' + studentSnapshot['lastName'],
            'phone': studentSnapshot['phone'],
          }]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking successful!")),
        );
      } else {
        showErrorDialog("User is not logged in");
      }
    } catch (e) {
      showErrorDialog("An error occurred: $e");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teachers for ${widget.subjectName}", // تعديل العنوان ليشمل اسم المادة
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // للرجوع للصفحة السابقة
          },
        ),
      ),
      endDrawer: Drawer( // جعل الـ Drawer على اليمين
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(studentName),
              accountEmail: Text(studentPhone),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  studentName[0],
                  style: const TextStyle(fontSize: 40.0, color: Colors.blueAccent),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blueAccent),
              title: Text('Edit Profile'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
                setState(() {
                  loadStudentData();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.blueAccent),
              title: Text('Registered Teachers'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentTeachersPage(studentId: user!.uid),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.blueAccent),
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
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('teachers')
              .where('subject', isEqualTo: widget.selectedSubject) // استعلام لجلب المدرسين الخاصين بالمادة
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(10.0),
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(doc['imageUrl']),
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minHeight: 159,
                          maxHeight: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Subject: ${doc['subject']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () => bookLesson(doc.id),
                                  icon: Icon(Icons.book),
                                  label: const Text(
                                    'Book',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
