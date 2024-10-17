import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  @override
  _ForgottenPasswordScreenState createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetPassword() async {
    // التحقق من أن البريد الإلكتروني صالح
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address.');
      return;
    }

    try {
      // إرسال رابط إعادة تعيين كلمة المرور باستخدام Firebase Auth
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      Fluttertoast.showToast(msg: 'Reset password email sent!');
      Navigator.pop(context); // العودة إلى شاشة تسجيل الدخول بعد الإرسال
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff3a69c8),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // العناصر في المنتصف عموديا
            crossAxisAlignment: CrossAxisAlignment.center, // العناصر في المنتصف أفقيا
            mainAxisSize: MainAxisSize.min, // تجنب ملء الشاشة بالكامل
            children: [
              const Text(
                'RESET PASSWORD',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffffffff),
                ),
              ),
              SizedBox(height: 30), // مسافة بين العنوان والمكون
              // مكون إدخال البريد الإلكتروني
              component1(Icons.email_outlined, 'Enter your email...', false, true, emailController),
              SizedBox(height: 20), // مسافة بين حقل الإدخال والزر
              // زر لإرسال طلب إعادة تعيين كلمة المرور
              InkWell(
                onTap: sendResetPassword,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xff6196ea),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text(
                    'SEND EMAIL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // مكون نص الحقل
  Widget component1(IconData icon, String hintText, bool isPassword, bool isEmail, TextEditingController controller) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff212428),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white.withOpacity(.9)),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(.7)),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
        ),
      ),
    );
  }
}

