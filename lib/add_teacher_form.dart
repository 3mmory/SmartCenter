import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTeacherForm extends StatefulWidget {
  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController adminIdController = TextEditingController();
  XFile? _teacherImage;

  Future<void> addTeacher() async {
    String adminId = adminIdController.text;

    // التحقق من ملء جميع الحقول
    if (nameController.text.isEmpty || subjectController.text.isEmpty || adminId.isEmpty || _teacherImage == null) {
      Fluttertoast.showToast(
        msg: "Please fill all fields and select an image.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // التحقق مما إذا كان adminId مستخدمًا من قبل
    bool adminIdExists = await checkIfAdminIdExists(adminId);

    if (adminIdExists) {
      Fluttertoast.showToast(
        msg: "Admin ID already exists!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      String imageUrl = await uploadTeacherImage(_teacherImage!);
      FirebaseFirestore.instance.collection('teachers').add({
        'name': nameController.text,
        'subject': subjectController.text,
        'imageUrl': imageUrl,
        'students': [],
        'adminId': adminId, // إضافة adminId لكل مدرس
      });
      Fluttertoast.showToast(
        msg: "Teacher added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context); // العودة إلى الشاشة السابقة بعد إضافة المدرس
    }
  }

  Future<bool> checkIfAdminIdExists(String adminId) async {
    final result = await FirebaseFirestore.instance
        .collection('teachers')
        .where('adminId', isEqualTo: adminId)
        .get();
    return result.docs.isNotEmpty;
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
        title: const Text(
          'Add Teacher',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
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
                  'Teacher Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
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
                TextField(
                  controller: adminIdController,
                  decoration: const InputDecoration(
                    labelText: 'Admin ID',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
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
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please select an image.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
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
                    onPressed: addTeacher,
                    child: const Text('Add Teacher'),
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
    );
  }
}
