import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:url_launcher/url_launcher.dart'; // For making phone calls

class ViewStudents extends StatelessWidget {
  final String teacherId;

  const ViewStudents({required this.teacherId});

  // Function to initiate a phone call
  _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      // Use launchUrl to open the phone dialer with the number
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneUri';
      }
    } catch (e) {
      print('Error making phone call: $e');
    }
  }

  // Function to copy the phone number to clipboard
  _copyToClipboard(BuildContext context, String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone number copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registered Students',
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
            colors: [Colors.indigoAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('teachers')
              .doc(teacherId)
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
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No students found.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            var teacherData = snapshot.data!.data() as Map<String, dynamic>;
            var students = teacherData['students'] ?? [];

            // Get the count of students
            int studentCount = students.length;

            if (students.isEmpty) {
              return const Center(
                child: Text(
                  'No students found.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Registered Students: $studentCount',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var student = students[index] as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 8,
                          shadowColor: Colors.blueAccent.withOpacity(0.4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            leading: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blueAccent,
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              student['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigoAccent,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.blueAccent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    student['phone'],
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.indigoAccent,
                              size: 28,
                            ),
                            onTap: () {
                              // Show options: Copy or Call
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.blueAccent[50],
                                  padding: const EdgeInsets.all(15),
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.copy, color: Colors.blueAccent),
                                        title: const Text('Copy Phone Number'),
                                        onTap: () {
                                          _copyToClipboard(context, student['phone']);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading:const Icon(Icons.phone, color: Colors.green),
                                        title: const Text('Call'),
                                        onTap: () {
                                          _makePhoneCall(student['phone']);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
