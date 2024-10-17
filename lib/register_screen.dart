import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: .7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    )..addListener(() {
      setState(() {});
    })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> register() async {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    if (!email.contains('@')) {
      Fluttertoast.showToast(msg: 'Invalid email format');
      return;
    }

    if (phone.length != 11 || !phone.startsWith('01')) {
      Fluttertoast.showToast(msg: 'Phone number must be 11 digits and start with 01');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String studentId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('students').doc(studentId).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'bookedTeachers': [],
        'studentId': studentId,
      });

      Fluttertoast.showToast(msg: 'Registration successful');
      Navigator.pushReplacementNamed(context, '/login');
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
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffffffff),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: component1(Icons.person_outline, 'First Name...', false, firstNameController)),
                            const SizedBox(width: 10),
                            Expanded(child: component1(Icons.person_outline, 'Last Name...', false, lastNameController)),
                          ],
                        ),
                        component1(Icons.phone_outlined, 'Phone...', false, phoneController),
                        component1(Icons.email_outlined, 'Email...', false, emailController),
                        componentPassword(Icons.lock_outline, 'Password...', true, passwordController, isPasswordVisible, () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        }),
                        componentPassword(Icons.lock_outline, 'Confirm Password...', true, confirmPasswordController, isConfirmPasswordVisible, () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account?',
                                style: const TextStyle(color: Color(0xffffffff)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.lightImpact();
                                    Navigator.pushNamed(context, '/login');
                                  },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: width * .07),
                          height: width * .7,
                          width: width * .7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Color(0xff09090A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Transform.scale(
                          scale: _animation.value,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              register();
                            },
                            child: Container(
                              height: width * .2,
                              width: width * .2,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xff6196ea),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget component1(IconData icon, String hintText, bool isPassword, TextEditingController controller) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 8,
      width: width / 2.5,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: width / 30),
      decoration: BoxDecoration(
        color: const Color(0xff212428),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white.withOpacity(.9)),
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(.7)),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
        ),
      ),
    );
  }

  Widget componentPassword(IconData icon, String hintText, bool isPassword, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 8,
      width: width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: width / 30),
      decoration: BoxDecoration(
        color: const Color(0xff212428),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white.withOpacity(.9)),
        obscureText: !isVisible,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(.7)),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white.withOpacity(.7),
            ),
            onPressed: toggleVisibility,
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
        ),
      ),
    );
  }
}

// Custom behavior to disable visual effects when scrolling
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
