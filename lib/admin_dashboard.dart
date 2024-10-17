import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_9_18/view_students.dart';
import 'EditTeacherForm.dart';
import 'add_teacher_form.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5, // إضافة ظل للشريط العلوي
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(10.0), // إضافة مساحة حول القائمة
            children: snapshot.data!.docs.map((doc) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3, // تأثير الظل على البطاقات
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(doc['imageUrl']),
                    backgroundColor: Colors.grey[200], // لون خلفية للصورة في حال عدم وجود صورة
                  ),
                  title: Text(
                    doc['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Subject: ${doc['subject']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewStudents(teacherId: doc.id),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blueAccent, // لون زر التعديل
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTeacherForm(
                                teacherId: doc.id,
                                currentName: doc['name'],
                                currentSubject: doc['subject'],
                                currentImageUrl: doc['imageUrl'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent, // لون زر الحذف
                        onPressed: () {
                          showDeleteConfirmationDialog(context, doc.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTeacherForm()),
          );
        },
        backgroundColor: Colors.greenAccent, // لون الزر العائم
        tooltip: 'Add Teacher',
        child: const Icon(Icons.add),
      ),
    );
  }

  // حوار لتأكيد الحذف
  void showDeleteConfirmationDialog(BuildContext context, String teacherId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Teacher"),
          content: const Text("Are you sure you want to delete this teacher?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('teachers')
                    .doc(teacherId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
