import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Services/Responsive.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Auth/Login/Controller/LoginController.dart';
import 'package:unity_test/View/Auth/Signup/Controller/SignupController.dart';
import 'package:unity_test/View/Auth/Signup/SignupPage.dart';
import 'package:unity_test/View/Guest/NavigationPage/Controller/NavegationPageGuestController.dart';
import 'package:unity_test/View/Guest/NavigationPage/NavegationPageGuest.dart';
import 'package:unity_test/Widgets/TextInput/TextInputCustom.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) => Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.secondery.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -120,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.secondery.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Form(
              key: keyform,
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                children: [
                  Gap(200),
                  Center(
                    child: Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                  ),
                  Gap(30),
                  TextInputCustom(
                    icon: Icon(Icons.email),
                    controller: controller.emailcontroller,
                    hint: "Email",
                  ),
                  Gap(20),
                  TextInputCustom(
                    controller: controller.passwordcontroller,
                    ispassword: true,
                    hint: "Password",
                    icon: Icon(Icons.password),
                  ),
                  Gap(20),
                  GestureDetector(
                    onTap: () async {
                      if (keyform.currentState!.validate()) {
                        EasyLoading.show();
                        try {
                          var result = await controller.Login(context);
                          result.fold(
                            (l) {
                              EasyLoading.showError(l.message);
                              EasyLoading.dismiss();
                            },
                            (r) {
                              EasyLoading.dismiss();
                            },
                          );
                        } catch (e) {
                          EasyLoading.dismiss();
                        }
                      }
                    },
                    child: Container(
                        width: Responsive.getWidth(context) * .4,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: AppColors.basic,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Gap(10),
                  TextButton(
                    onPressed: () {
                      CustomRoute.RouteReplacementTo(
                          context,
                          ChangeNotifierProvider(
                            create: (context) => SignupController(),
                            builder: (context, child) => SignupPage(),
                          ));
                    },
                    child: Text(
                      'Create a new account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                  ),
                  Gap(20),
                  GestureDetector(
                    onTap: () {
                      CustomRoute.RouteAndRemoveUntilTo(
                          context,
                          ChangeNotifierProvider(
                            create: (context) =>
                                NavegationPageGuestController(),
                            builder: (context, child) => NavegationPageGuest(),
                          ));
                    },
                    child: Container(
                      width: Responsive.getWidth(context) * .4,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.secondery,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "Continue As Guest",
                          style: TextStyle(
                              color: AppColors.basic,
                              fontWeight: FontWeight.bold),
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
    );
  }
}
