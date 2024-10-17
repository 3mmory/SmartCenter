import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class StudentTeachersPage extends StatelessWidget {
  final String studentId;

  const StudentTeachersPage({super.key, required this.studentId});

  _removeRegistration(BuildContext context, String teacherId) async {
    try {
      var teacherDoc = FirebaseFirestore.instance.collection('teachers').doc(teacherId);
      await teacherDoc.update({
        'students': FieldValue.arrayRemove([{
          'studentId': studentId,
        }]),
      });

      await FirebaseFirestore.instance.collection('students').doc(studentId).update({
        'bookedTeachers': FieldValue.arrayRemove([teacherId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully removed registration.')),
      );
    } catch (e) {
      print('Error removing registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove registration.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Teachers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
              return const Center(
                child: Text(
                  'No teachers found.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            var studentData = snapshot.data!.data() as Map<String, dynamic>;
            var bookedTeachers = studentData['bookedTeachers'] ?? [];

            return bookedTeachers.isEmpty
                ? Center(
              child: Text(
                'No teachers found.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : ListView.builder(
              itemCount: bookedTeachers.length,
              itemBuilder: (context, index) {
                var teacherId = bookedTeachers[index];

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(teacherId)
                      .snapshots(),
                  builder: (context, teacherSnapshot) {
                    if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const ListTile(
                          leading: CircleAvatar(radius: 30),
                          title: Text(
                            'Loading...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }
                    if (teacherSnapshot.hasError || !teacherSnapshot.hasData || teacherSnapshot.data!.data() == null) {
                      return const SizedBox(); // Ignore errors for individual teachers
                    }

                    var teacherData = teacherSnapshot.data?.data() as Map<String, dynamic>? ?? {};

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        shadowColor: Colors.blueAccent.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.blueAccent,
                                    backgroundImage: NetworkImage(teacherData['imageUrl'] ?? ''),
                                    child: teacherData['imageUrl'] == null
                                        ? const FaIcon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          teacherData['name'] ?? 'Unknown Teacher',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.indigoAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          teacherData['subject'] ?? 'No subject',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _removeRegistration(context, teacherId);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
