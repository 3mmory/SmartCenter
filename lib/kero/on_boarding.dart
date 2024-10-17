// import 'package:flutter/material.dart';
// import '../login_screen.dart';
// import 'app_image.dart';
//
// class OnBoardingView extends StatefulWidget {
//   const OnBoardingView({super.key});
//
//   @override
//   State<OnBoardingView> createState() => _OnBoardingViewState();
// }
//
// class _OnBoardingViewState extends State<OnBoardingView> {
//   final list = [
//     _Model(
//         title: "Welcome to\nSmart Center",
//         desc: "Discover a wide variety of denim dummies and customizations for all levels, from primary to high school.",
//         image: "on_boarding1.jpg"),
//     _Model(
//         title: "Specialized Teachers",
//         desc: "Learn from the best teachers in a variety of subjects, and get individual support to help you achieve your academic goals.",
//         image: "on_boarding2.jpg"),
//     _Model(
//         title: "Various Subjects",
//         desc: "Enjoy the variety of subjects we offer, from math to languages and science, and prepare for success in your studies.",
//         image: "on_boarding3.jpg"),
//   ];
//
//   int currentPage = 0;
//   final pageController = PageController();
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: screenHeight * 0.5, // 50% of the screen height
//               child: PageView.builder(
//                 controller: pageController,
//                 itemCount: list.length,
//                 onPageChanged: (value) {
//                   setState(() {
//                     currentPage = value;
//                   });
//                 },
//                 itemBuilder: (context, index) => AppImage(
//                   list[index].image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02), // Dynamic spacing
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: List.generate(
//                 list.length,
//                     (index) => Padding(
//                   padding: const EdgeInsetsDirectional.only(end: 8),
//                   child: CircleAvatar(
//                     radius: screenWidth * 0.012, // Responsive size
//                     backgroundColor: currentPage == index
//                         ? Colors.blue[900]
//                         : const Color(0xffD9D9D9),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02), // Dynamic spacing
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Align(
//                 alignment: AlignmentDirectional.centerStart,
//                 child: Text(
//                   list[currentPage].title,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.08, // Responsive text size
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02), // Dynamic spacing
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Align(
//                 alignment: AlignmentDirectional.centerStart,
//                 child: Text(
//                   list[currentPage].desc,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.045, // Responsive text size
//                     color: const Color(0xff7E7E7E),
//                   ),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Row(
//                 children: [
//                   if (currentPage != list.length - 1)
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => const LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "Skip",
//                         style: TextStyle(
//                           color: Colors.blue[900],
//                           fontSize: screenWidth * 0.045, // Responsive text size
//                         ),
//                       ),
//                     ),
//                   const Spacer(),
//                   FloatingActionButton(
//                     backgroundColor: Colors.blue[900],
//                     onPressed: () {
//                       if (currentPage == list.length - 1) {
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => const LoginScreen(),
//                           ),
//                         );
//                       } else {
//                         pageController.nextPage(
//                           duration: const Duration(milliseconds: 650),
//                           curve: Curves.linear,
//                         );
//                       }
//                     },
//                     child: const Icon(Icons.arrow_forward),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.05), // Dynamic spacing
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _Model {
//   final String image, title, desc;
//
//   _Model({
//     required this.image,
//     required this.title,
//     required this.desc,
//   });
// }
