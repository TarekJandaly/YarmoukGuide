import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';

import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Services/Responsive.dart';
import 'package:ypu_dashboard/View/Auth/Login/Controller/LoginController.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final keyform = GlobalKey<FormState>();

  // Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          "Admin Dashboard",
          style: TextStyles.header.copyWith(color: AppColors.basic),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.primary,
                  width: Responsive.getWidth(context),
                  height: 200,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.basic,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
            width: Responsive.getWidth(context),
            child: ListView(
              padding: EdgeInsets.all(30),
              children: [
                Gap(30),
                Consumer<LoginController>(
                  builder: (context, controller, child) => ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      TextInputCustom(
                        icon: Icon(
                          Icons.email,
                          color: AppColors.primary,
                        ),
                        hint: "Email",
                        ispassword: false,
                        controller: controller.emailcontroller,
                        type: TextInputType.text,
                      ),
                      Gap(20),
                      TextInputCustom(
                        icon: Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                        ),
                        hint: "Password",
                        ispassword: true,
                        controller: controller.passwordcontroller,
                        type: TextInputType.text,
                      ),
                      Gap(30),
                      GestureDetector(
                        onTap: () async {
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 50,
            child: Container(
              height: 75,
              width: 150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(200),
                  topLeft: Radius.circular(200),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.secondery,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
