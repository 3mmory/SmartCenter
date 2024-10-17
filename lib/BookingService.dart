import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  // دالة لحجز مدرس
  Future<void> bookTeacher(String studentId, String teacherId) async {
    try {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      List<dynamic> bookedTeachers = studentSnapshot['bookedTeachers'];

      if (bookedTeachers.contains(teacherId)) {
        throw Exception("You've already booked this teacher.");
      }

      if (bookedTeachers.length >= 6) {
        throw Exception("You can't book more than 6 teachers.");
      }

      // إذا كانت الشروط صحيحة، أضف teacherId إلى قائمة الحجز
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .update({
        'bookedTeachers': FieldValue.arrayUnion([teacherId]),
      });

      // تحديث معلومات المدرس لإضافة الطالب إلى قائمة طلابه
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .update({
        'students': FieldValue.arrayUnion([{
          'studentId': studentId,
          'name': studentSnapshot['firstName'] + ' ' + studentSnapshot['lastName'],
          'phone': studentSnapshot['phone'],
        }]),
      });

      print("Booking successful!");
    } catch (e) {
      print("Error booking teacher: $e");
    }
  }
}
