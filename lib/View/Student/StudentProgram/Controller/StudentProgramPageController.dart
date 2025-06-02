import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Course.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:unity_test/Services/Routes.dart';

class StudentProgramPageController with ChangeNotifier {
  List<Course> course = [];
  List<Course> schedulecourses = [];
  List<Course> selectedCourses = []; // قائمة المواد المختارة
  // دالة لتبديل حالة المادة بين "محددة" و "غير محددة"
  void toggleCourseSelection(Course selectedCourse) {
    if (selectedCourses.contains(selectedCourse)) {
      selectedCourses.remove(selectedCourse);
    } else {
      selectedCourses.add(selectedCourse);
    }
    notifyListeners();
  }

  // دالة للتحقق إذا كانت المادة محددة
  bool isCourseSelected(Course course) {
    return selectedCourses.contains(course);
  }

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetcourse = false;
  Future<void> GetAvailableCourse(BuildContext context) async {
    course = [];
    isloadinggetcourse = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAvailableCourse,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          course.add(Course.fromJson(element));
        }
        isloadinggetcourse = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetcourse = false;
        notifyListeners();
      } else {
        isloadinggetcourse = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetcourse = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  bool isloadinggetschedulecourse = false;
  Future<void> GetStudentCourses(BuildContext context) async {
    schedulecourses = [];
    isloadinggetschedulecourse = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetStudentCourses,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          schedulecourses.add(Course.fromJson(element));
        }
        isloadinggetschedulecourse = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetschedulecourse = false;
        notifyListeners();
      } else {
        isloadinggetschedulecourse = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetschedulecourse = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  Future<void> RegisterMultipleCourses(BuildContext context) async {
    EasyLoading.show();
    try {
      final response = await client.request(
          requestType: RequestType.POST,
          path: AppApi.RegisterMultipleCourses,
          body: jsonEncode(
              {"course_ids": selectedCourses.map((e) => e.id).toList()}));
      log(response.body);
      log(response.statusCode.toString());
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CustomDialog.DialogSuccess(context, title: data['message']);
        GetAvailableCourse(context);
        CustomRoute.RoutePop(context);
        EasyLoading.dismiss();
      } else if (response.statusCode == 404) {
        CustomDialog.DialogError(context, title: data['message']);
        EasyLoading.dismiss();
      } else if (response.statusCode == 400) {
        CustomDialog.DialogError(context, title: data['message']);
        EasyLoading.dismiss();
      } else {
        CustomDialog.DialogError(context, title: data['message']);
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(GlobalFailure().message);

      log(e.toString());
      log("error in this fun");
    }
  }

  DialogRegisterCourse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Courses Selected"),
        actions: [
          ElevatedButton(
              onPressed: () => RegisterMultipleCourses(context),
              child: Text("Next")),
          TextButton(
              onPressed: () => CustomRoute.RoutePop(context),
              child: Text("close")),
        ],
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: selectedCourses
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.basic,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              color: AppColors.black.withAlpha(50),
                              offset: Offset(0, 3.5),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${e.name!} ${e.type! == 'practical' ? "(P)" : "(T)"}",
                                style: TextStyles.title,
                              ),
                              Text(e.code!, style: TextStyles.inputtitle),
                              Gap(10),
                              Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(e.day!),
                                  Text(e.time ?? 'Unknown'),
                                  Icon(Icons.arrow_forward, size: 15),
                                  Text(e.time_end ?? 'Unknown'),
                                  Text("(${e.hall!.name!})"),
                                ],
                              ),
                              Gap(10),
                              Text("Dr. ${e.doctors![0].user!.name}"),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  DialogScheduleCourses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Schedule Courses"),
        actions: [
          TextButton(
              onPressed: () => CustomRoute.RoutePop(context),
              child: Text("close")),
        ],
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DataTable(
                  columns: [
                    DataColumn(
                      label: Text("Course"),
                    ),
                    DataColumn(
                      label: Text("Day"),
                    ),
                    DataColumn(
                      label: Text("Time Start"),
                    ),
                    DataColumn(
                      label: Text("Time End"),
                    ),
                    DataColumn(
                      label: Text("Doctor"),
                    ),
                    DataColumn(
                      label: Text("Type"),
                    ),
                    DataColumn(
                      label: Text("Room"),
                    )
                  ],
                  rows: schedulecourses
                      .map((e) => DataRow(cells: [
                            DataCell(
                              Text(e.name!),
                            ),
                            DataCell(
                              Text(e.day!),
                            ),
                            DataCell(
                              Text(e.time!),
                            ),
                            DataCell(
                              Text(e.time_end ?? ""),
                            ),
                            DataCell(
                              Text(e.doctors?[0].user?.name ?? ""),
                            ),
                            DataCell(
                              Text(e.type!),
                            ),
                            DataCell(
                              Text(e.hall!.name!),
                            )
                          ]))
                      .toList())
            ],
          ),
        ),
      ),
    );
  }
}
