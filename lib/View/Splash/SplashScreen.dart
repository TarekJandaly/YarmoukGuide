import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Auth/Login/Controller/LoginController.dart';
import 'package:unity_test/View/Doctor/NavigationPage/Controller/NavegationPageDoctorController.dart';
import 'package:unity_test/View/Doctor/NavigationPage/NavegationPageDoctor.dart';
import 'package:unity_test/View/Employee/NavigationPage/Controller/NavegationPageEmployeeController.dart';
import 'package:unity_test/View/Employee/NavigationPage/NavegationPageEmployee.dart';
import 'package:unity_test/View/Student/NavigationPage/Controller/NavegationPageStudentController.dart';
import 'package:unity_test/View/Student/NavigationPage/NavegationPageStudent.dart';
// import 'package:unity_test/employee_screen.dart';
// import 'package:unity_test/teacher_screen.dart';
import 'dart:async';
import 'dart:ui';
import '../Auth/Login/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // تأثير التلاشي (Fade)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // تأثير التكبير (Scale)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // تشغيل الأنيميشن
    _controller.forward();

    // الانتقال بعد انتهاء الأنيميشن
    Timer(const Duration(seconds: 4), () async {
      if (await ServicesProvider.isLoggin()) {
        String role = await ServicesProvider.getRole();
        switch (role) {
          case 'student':
            CustomRoute.RouteReplacementTo(
                context,
                ChangeNotifierProvider(
                  create: (context) => NavegationPageStudentController(),
                  builder: (context, child) => NavegationPageStudent(),
                ));

            break;
          case 'doctor':
            CustomRoute.RouteReplacementTo(
                context,
                ChangeNotifierProvider(
                  create: (context) => NavegationPageDoctorController(),
                  builder: (context, child) => NavegationPageDoctor(),
                ));
            break;
          case 'employee':
            CustomRoute.RouteReplacementTo(
                context,
                ChangeNotifierProvider(
                  create: (context) => NavegationPageEmployeeController(),
                  builder: (context, child) => NavegationPageEmployee(),
                ));
            break;
          default:
          // _showSnackBar('Invalid user type');
        }
      } else {
        CustomRoute.RouteAndRemoveUntilTo(
            context,
            ChangeNotifierProvider(
              create: (context) => LoginController(),
              builder: (context, child) => LoginPage(),
            ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الصورة مع التمويه (Blur)
          Positioned.fill(
            child: Image.asset(
              'assets/images/ypu-2011_0517.jpg', // استبدلها بالصورة الخاصة بك
              fit: BoxFit.cover,
            ),
          ),

          // تأثير التمويه
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10, sigmaY: 10), // تطبيق التمويه القوي
              child: Container(
                color: Colors.transparent, // الحفاظ على الصورة بدون لون إضافي
              ),
            ),
          ),

          // الشعار مع الأنيميشن
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/Logo.png', // استبدلها بمسار شعارك
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
