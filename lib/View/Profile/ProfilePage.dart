// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/Services/Responsive.dart';
import 'package:unity_test/View/Profile/Controller/ProfilePageController.dart';
import 'package:unity_test/Widgets/TextInput/TextInputCustom.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Skeletonizer(
          enabled: controller.isloadinggetprofile,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Container(
                        color: AppColors.secondery,
                        width: 200,
                        height: 200,
                        child: controller.imagesfile != null
                            ? Image.file(
                                File(controller.imagesfile!.path),
                                fit: BoxFit.cover,
                              )
                            : controller.user.profilePicture != null
                                ? Image.network(
                                    "${AppApi.urlImage}${controller.user.profilePicture!}",
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 100,
                                    color: AppColors.basic,
                                  )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        controller.pickimage(context);
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Change Image")),
                  if (controller.imagesfile != null) Gap(10),
                  if (controller.imagesfile != null)
                    ElevatedButton(
                      onPressed: () {
                        controller.imagesfile = null;
                        controller.notifyListeners();
                      },
                      child: Icon(Icons.delete),
                    ),
                  if (controller.imagesfile != null) Gap(10),
                  if (controller.imagesfile != null)
                    ElevatedButton(
                      onPressed: () {
                        controller.UpdateImageProfile(context);
                      },
                      child: Icon(Icons.upload),
                    ),
                ],
              ),
              Gap(20),
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
              if (ServicesProvider.getRole() == 'student' ||
                  ServicesProvider.getRole() == 'doctor')
                Gap(10),
              if (ServicesProvider.getRole() == 'student' ||
                  ServicesProvider.getRole() == 'doctor')
                TextInputCustom(
                  controller: controller.majorController,
                  hint: "Specialization",
                  icon: Icon(Icons.workspace_premium),
                  enable: false,
                ),
              if (ServicesProvider.getRole() == 'student') Gap(10),
              if (ServicesProvider.getRole() == 'student')
                TextInputCustom(
                  controller: controller.yearController,
                  hint: "Registered Year",
                  icon: Icon(Icons.calendar_month),
                  enable: false,
                ),
              if (ServicesProvider.getRole() == 'student') Gap(10),
              if (ServicesProvider.getRole() == 'student')
                TextInputCustom(
                  controller: controller.universitynumberController,
                  hint: "University Number",
                  icon: Icon(Icons.numbers),
                  enable: false,
                ),
              if (ServicesProvider.getRole() == 'employee') Gap(10),
              if (ServicesProvider.getRole() == 'employee')
                TextInputCustom(
                  controller: controller.departmentController,
                  hint: "Department",
                  icon: Icon(Icons.event_seat),
                  enable: false,
                ),
              Gap(20),
              GestureDetector(
                onTap: () async {
                  EasyLoading.show();
                  try {
                    var result = await controller.UpdateProfile(context);
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
                        "Update",
                        style: TextStyle(
                            color: AppColors.basic,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
