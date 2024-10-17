import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditTeacherForm extends StatefulWidget {
  final String teacherId;
  final String currentName;
  final String currentSubject;
  final String currentImageUrl;

  EditTeacherForm({
    required this.teacherId,
    required this.currentName,
    required this.currentSubject,
    required this.currentImageUrl,
  });

  @override
  _EditTeacherFormState createState() => _EditTeacherFormState();
}

class _EditTeacherFormState extends State<EditTeacherForm> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  XFile? _teacherImage;
  String? newImageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentName;
    subjectController.text = widget.currentSubject;

    // استرجاع قيمة adminId من Firestore
    fetchAdminId();
  }

  Future<void> fetchAdminId() async {
    DocumentSnapshot teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(widget.teacherId).get();
    if (teacherDoc.exists) {
      var data = teacherDoc.data() as Map<String, dynamic>;
      idController.text = data['adminId'] ?? ''; // تعيين adminId في حقل الإدخال
    }
  }

  Future<void> updateTeacher() async {
    if (idController.text.isEmpty || nameController.text.isEmpty || subjectController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (_teacherImage != null) {
      newImageUrl = await uploadTeacherImage(_teacherImage!);
    } else {
      newImageUrl = widget.currentImageUrl; // استخدام الصورة الحالية إذا لم يتم تغييرها
    }

    // تحديث بيانات المعلم
    await FirebaseFirestore.instance.collection('teachers').doc(widget.teacherId).update({
      'name': nameController.text,
      'subject': subjectController.text,
      'imageUrl': newImageUrl,
      'adminId': idController.text, // تحديث الـ ID
    });

    Fluttertoast.showToast(
      msg: "Teacher updated successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Navigator.pop(context); // العودة إلى صفحة الداشبورد بعد التحديث
  }

  Future<String> uploadTeacherImage(XFile imageFile) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('teacher_images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Teacher',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade100, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Teacher Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Admin ID',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Teacher Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.subject, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        _teacherImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (_teacherImage != null) {
                          Fluttertoast.showToast(
                            msg: "Image selected successfully!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Pick New Image'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateTeacher,
                      child: const Text('Update Teacher'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
