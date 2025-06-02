import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/firebase_options.dart';
import 'View/Splash/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unity Test',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.basic,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => AppColors.primary),
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.secondery,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
          ),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.primary,
              displayColor: AppColors.primary,
              fontFamily: "Arima"),
          useMaterial3: false,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondery,
          ).copyWith(background: AppColors.primary),
        ),
        home: SplashScreen(),
        builder: (context, child) {
          EasyLoading.instance
            ..displayDuration = const Duration(seconds: 3)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorSize = 45.0
            ..radius = 15.0
            ..maskType = EasyLoadingMaskType.black
            ..progressColor = AppColors.secondery
            ..backgroundColor = AppColors.basic
            ..indicatorColor = AppColors.secondery
            ..textColor = AppColors.secondery
            ..maskColor = Colors.black
            ..userInteractions = false
            ..animationStyle = EasyLoadingAnimationStyle.opacity
            ..dismissOnTap = false;
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }
}
