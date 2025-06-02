// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Auth/Login/Controller/LoginController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ypu_dashboard/View/Auth/Login/Login.dart';

class ServicesProvider with ChangeNotifier {
  static SharedPreferences? sharedPreferences;
  ServicesProvider();

  static String getToken() {
    Future.delayed(Duration.zero).then((value) async {
      sharedPreferences = await SharedPreferences.getInstance();
    });
    return sharedPreferences!.getString('token') ?? '';
  }

  static String getRole() {
    Future.delayed(Duration.zero).then((value) async {
      sharedPreferences = await SharedPreferences.getInstance();
    });
    return sharedPreferences!.getString('role') ?? '';
  }

  static Future<void> saveTokenAndRole(String token, String role) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('token', token);
    await sharedPreferences!.setString('role', role);
    await sharedPreferences!.setBool('isLoggin', true);
  }

  static Future<void> logout(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.remove('token');
    sharedPreferences!.remove('role');
    sharedPreferences!.remove('isLoggin');
    CustomRoute.RouteAndRemoveUntilTo(
        context,
        ChangeNotifierProvider(
          create: (context) => LoginController(),
          builder: (context, child) => Login(),
        ));
    CustomDialog.DialogSuccess(context, title: "Logout successfully");
  }

  static Future<bool> isLoggin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences!.getBool('isLoggin') ?? false;
  }

  Future<SharedPreferences> sharedprefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences!;
  }
}
