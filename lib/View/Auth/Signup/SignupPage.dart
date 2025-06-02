import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';

import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Services/Responsive.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Auth/Login/Controller/LoginController.dart';
import 'package:unity_test/View/Auth/Login/LoginPage.dart';
import 'package:unity_test/View/Auth/Signup/Controller/SignupController.dart';
import 'package:unity_test/Widgets/TextInput/TextInputCustom.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (context, controller, child) => Scaffold(
        body: Stack(
          children: [
            // الدائرتان الزخرفيتان
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
                padding: EdgeInsets.all(16.0),
                physics: BouncingScrollPhysics(),
                children: [
                  Gap(100),
                  Center(
                    child: Text(
                      'Create a new account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                  ),
                  Gap(30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: AppColors.black.withAlpha(50),
                          offset: Offset(0, 3.5),
                        )
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.admin_panel_settings),
                        isDense: true,
                        fillColor: AppColors.basic,
                        labelText: 'User type',
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                      ),
                      value: controller.selectedUserType,
                      onChanged: (newValue) {
                        controller.changeType(newValue);
                      },
                      items: controller.userTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                  ),
                  Gap(10),
                  TextInputCustom(
                    controller: controller.namecontroller,
                    hint: "Name",
                    icon: Icon(Icons.person),
                  ),
                  Gap(10),
                  TextInputCustom(
                    controller: controller.emailcontroller,
                    hint: "Email",
                    icon: Icon(Icons.email),
                  ),
                  Gap(10),
                  TextInputCustom(
                    controller: controller.phonecontroller,
                    hint: "Phone",
                    icon: Icon(Icons.phone),
                  ),
                  Gap(10),
                  TextInputCustom(
                    controller: controller.passwordcontroller,
                    ispassword: true,
                    hint: "Password",
                    icon: Icon(Icons.password),
                  ),
                  Gap(10),

                  /// ✅ **إضافة الحقول الإضافية حسب نوع المستخدم**
                  if (controller.selectedUserType == 'student' ||
                      controller.selectedUserType == 'doctor')
                    TextInputCustom(
                      controller: controller.majorController,
                      hint: "Specialization",
                      icon: Icon(Icons.workspace_premium),
                    ),
                  Gap(10),
                  if (controller.selectedUserType == 'student')
                    TextInputCustom(
                      controller: controller.yearController,
                      hint: "Registered Year",
                      icon: Icon(Icons.calendar_month),
                    ),
                  Gap(10),

                  if (controller.selectedUserType == 'student')
                    TextInputCustom(
                      controller: controller.universitynumberController,
                      hint: "University Number",
                      icon: Icon(Icons.numbers),
                    ),

                  if (controller.selectedUserType == 'employee')
                    TextInputCustom(
                      controller: controller.departmentController,
                      hint: "Department",
                      icon: Icon(Icons.event_seat),
                    ),

                  Gap(20),
                  GestureDetector(
                    onTap: () async {
                      if (keyform.currentState!.validate()) {
                        EasyLoading.show();
                        try {
                          var result = await controller.Signup(context);
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
                            "Signup",
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
                            create: (context) => LoginController(),
                            builder: (context, child) => LoginPage(),
                          ));
                    },
                    child: Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondery,
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
