import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_9_18/register_screen.dart';

import 'admin_dashboard.dart';


import 'login_screen.dart';
import 'newhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:LoginScreen(),
      //SplashView(nextPage: OnBoardingView(),),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
      // '/student_dashboard': (context) => StudentDashboard(),
        '/admin_dashboard': (context) => AdminDashboard(),

      },
    );
  }
}
