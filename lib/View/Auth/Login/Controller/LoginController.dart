import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Doctor/NavigationPage/Controller/NavegationPageDoctorController.dart';
import 'package:unity_test/View/Doctor/NavigationPage/NavegationPageDoctor.dart';
import 'package:unity_test/View/Employee/NavigationPage/Controller/NavegationPageEmployeeController.dart';
import 'package:unity_test/View/Employee/NavigationPage/NavegationPageEmployee.dart';
import 'package:unity_test/View/Student/NavigationPage/Controller/NavegationPageStudentController.dart';
import 'package:unity_test/View/Student/NavigationPage/NavegationPageStudent.dart';

class LoginController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  Future<Either<Failure, bool>> Login(BuildContext context) async {
    var fcmToken = await messaging.getToken();
    log(fcmToken.toString());
    try {
      final response = await client.request(
        path: AppApi.LOGIN,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "email": emailcontroller.text,
            "password": passwordcontroller.text,
            "device_token": fcmToken,
          },
        ),
      );
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        ServicesProvider.saveTokenAndRole(
            data['data']['token'], data['data']['role']);
        String role = await data['data']['role'];

        switch (role) {
          case 'student':
            CustomDialog.DialogSuccess(context, title: data['message']);

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

        return Right(true);
      } else if (response.statusCode == 401) {
        CustomDialog.DialogError(context, title: data['message']);
        return Right(true);
      } else if (response.statusCode == 404) {
        return Left(ResultFailure(data['message']));
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      log(e.toString());
      log("error in this fun");
      return Left(GlobalFailure());
    }
  }
}
