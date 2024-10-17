import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff004aad), // لون الخلفية
      appBar: AppBar(
        backgroundColor: const Color(0xff004aad), // لون الـ AppBar
        title: const Text('Lesson Pricing', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // النص العلوي التوضيحي
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Prices of Lessons for Each Grade',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Card للصف الإعدادي
            Card(
              color: const Color(0xff212428),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(Icons.school, color: Colors.blue[400], size: 40),
                  title: const Text(
                    'Preparatory Grade Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '40 EGP per lesson',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // مساحة بين الـ Cards
            // Card للصف الثانوي
            Card(
              color: const Color(0xff212428),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(Icons.school, color: Colors.blue[400], size: 40),
                  title: const Text(
                    'Secondary Grade Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '50 EGP per lesson',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
