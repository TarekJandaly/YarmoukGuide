import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Course.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class LectureSchedulePageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());

  List<Course> schedulecourses = [];
  bool isloadinggetschedulecourse = false;
  Future<void> GetDoctorCourses(BuildContext context) async {
    schedulecourses = [];
    isloadinggetschedulecourse = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetDoctorCourses,
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
}
