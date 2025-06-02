import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Controller/ListProvider.dart';
import 'package:ypu_dashboard/View/Splash/Controller/SplashController.dart';
import 'package:ypu_dashboard/View/Splash/splash.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: listproviders,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1280, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Admin',
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.basic,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.primary),
                ),
              ),
              iconTheme: IconThemeData(
                color: AppColors.primary,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: AppColors.primary,
                    displayColor: AppColors.primary,
                  ),
              useMaterial3: false,
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                secondary: AppColors.secondery,
              ).copyWith(background: AppColors.primary),
            ),
            home: ChangeNotifierProvider(
              create: (context) => SplashController()..whenIslogin(context),
              builder: (context, child) => Splash(),
            ),
            builder: (context, child) {
              EasyLoading.instance
                ..displayDuration = const Duration(seconds: 3)
                ..indicatorType = EasyLoadingIndicatorType.fadingCircle
                ..loadingStyle = EasyLoadingStyle.custom
                ..indicatorSize = 45.0
                ..radius = 15.0
                ..maskType = EasyLoadingMaskType.black
                ..progressColor = AppColors.primary
                ..backgroundColor = AppColors.basic
                ..indicatorColor = AppColors.primary
                ..textColor = AppColors.primary
                ..maskColor = Colors.black
                ..userInteractions = false
                ..animationStyle = EasyLoadingAnimationStyle.opacity
                ..dismissOnTap = false;
              return FlutterEasyLoading(child: child);
            },
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
