import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Auth/Login/Controller/LoginController.dart';
import 'package:unity_test/View/Auth/Login/LoginPage.dart';
import 'package:http/http.dart' as http;

class SignupController with ChangeNotifier {
  String? selectedUserType;
  final List<String> userTypes = ['student', 'doctor', 'employee'];

  changeType(var value) {
    selectedUserType = value;
    notifyListeners();
  }
  // // ✅ دالة تسجيل المستخدم عبر API
  // Future<void> _registerUser() async {
  //   final url = Uri.parse('https://your-api-url.com/register');

  //   Map<String, dynamic> requestBody = {
  //     'name': nameController.text,
  //     'email': emailController.text,
  //     'phone': phoneController.text,
  //     'password': passwordController.text,
  //     'userType': selectedUserType,
  //   };

  //   if (selectedUserType == 'Student') {
  //     requestBody['major'] = majorController.text;
  //     requestBody['year'] = yearController.text;
  //   } else if (selectedUserType == 'Teacher') {
  //     requestBody['major'] = majorController.text;
  //   } else if (selectedUserType == 'Employee') {
  //     requestBody['department'] = departmentController.text;
  //   }

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content:
  //               Text('Account created successfully! Redirecting to login...'),
  //           backgroundColor: Colors.green,
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //       Future.delayed(const Duration(seconds: 2), () {
  //         Navigator.pop(context);
  //       });
  //     } else {
  //       final errorMessage =
  //           jsonDecode(response.body)['message'] ?? 'Registration failed';
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('An error occurred: $e'),
  //           backgroundColor: Colors.red),
  //     );
  //   }
  // }
  static NetworkClient client = NetworkClient(http.Client());

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController universitynumberController = TextEditingController();
  @override
  void dispose() {
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
    log("close signup");
    super.dispose();
  }

  Future<Either<Failure, bool>> Signup(BuildContext context) async {
    Map<String, dynamic> requestBody = {
      'name': namecontroller.text,
      'email': emailcontroller.text,
      'phone': phonecontroller.text,
      'password': passwordcontroller.text,
      'role': selectedUserType,
    };

    if (selectedUserType == 'student') {
      requestBody['university_number'] = universitynumberController.text;
      requestBody['specialization'] = majorController.text;
      requestBody['registered_year'] = yearController.text;
    } else if (selectedUserType == 'doctor') {
      requestBody['specialization'] = majorController.text;
    } else if (selectedUserType == 'employee') {
      requestBody['department'] = departmentController.text;
    }
    try {
      var response = await client.request(
        path: AppApi.REGISTER,
        requestType: RequestType.POST,
        body: jsonEncode(requestBody),
      );

      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 201) {
        CustomRoute.RouteReplacementTo(
          context,
          ChangeNotifierProvider(
            create: (context) => LoginController(),
            lazy: true,
            builder: (context, child) => LoginPage(),
          ),
        );
        CustomDialog.DialogSuccess(context,
            title: "Create account was successfully");
        return Right(true);
      } else if (response.statusCode == 404) {
        return Left(ResultFailure(''));
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      log(e.toString());
      log("error in this fun");
      return Left(GlobalFailure());
    }
  }

  toLoginPage(BuildContext context) {
    CustomRoute.RouteReplacementTo(
      context,
      ChangeNotifierProvider(
        create: (context) => LoginController(),
        lazy: true,
        builder: (context, child) => LoginPage(),
      ),
    );
  }
}
