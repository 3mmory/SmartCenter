import 'dart:async';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  final Widget nextPage;
  final int durationSeconds;

  const SplashView({Key? key, required this.nextPage, this.durationSeconds = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timer للانتقال إلى الصفحة التالية بعد انقضاء مدة السبلاتش
    Timer(Duration(seconds: durationSeconds), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => nextPage, // الصفحة التالية بعد السبلاتش
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // صورة السبلاتش (الشعار)
          width: MediaQuery.of(context).size.width * 0.7, // تعديل حجم الشعار
          height: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}
