// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Controller/ServicesProvider.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Admin/Home/Controller/HomeController.dart';
import 'package:ypu_dashboard/View/Admin/Home/Home.dart';

class LoginController with ChangeNotifier {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.clear();
    passwordcontroller.clear();
    log("close login");
    super.dispose();
  }

  static NetworkClient client = NetworkClient(http.Client());
  Future<Either<Failure, bool>> Login(BuildContext context) async {
    log(emailcontroller.text);
    log(passwordcontroller.text);
    try {
      final response = await client.request(
        path: AppApi.LOGIN,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "email": emailcontroller.text,
            "password": passwordcontroller.text,
            "fcmtoken": "no token",
          },
        ),
      );
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        ServicesProvider.saveTokenAndRole(
            data['data']['token'], data['data']['role']);
        CustomRoute.RouteAndRemoveUntilTo(
            context,
            ChangeNotifierProvider(
              create: (context) => HomeController(),
              builder: (context, child) => Home(),
            ));
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
}
