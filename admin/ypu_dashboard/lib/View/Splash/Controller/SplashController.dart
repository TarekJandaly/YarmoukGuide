// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ypu_dashboard/Controller/ServicesProvider.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Admin/Home/Controller/HomeController.dart';
import 'package:ypu_dashboard/View/Admin/Home/Home.dart';
import 'package:ypu_dashboard/View/Auth/Login/Controller/LoginController.dart';
import 'package:ypu_dashboard/View/Auth/Login/Login.dart';
import 'package:provider/provider.dart';

class SplashController with ChangeNotifier {
  @override
  dispose() {
    log("close splash");
    super.dispose();
  }

  whenIslogin(BuildContext context) async {
    Future.delayed(Duration(seconds: 2)).then((value) async {
      if (await ServicesProvider.isLoggin()) {
        toHomeePage(context);
      } else {
        toLoginPage(context);
      }
    });
  }

  toLoginPage(BuildContext context) {
    CustomRoute.RouteReplacementTo(
      context,
      ChangeNotifierProvider<LoginController>(
        create: (context) => LoginController(),
        // builder: (context, child) => Login(),
        child: Login(),
      ),
    );
  }

  toHomeePage(BuildContext context) {
    CustomRoute.RouteReplacementTo(
      context,
      ChangeNotifierProvider<HomeController>(
        create: (context) => HomeController(),
        child: Home(),
      ),
    );
  }
}
