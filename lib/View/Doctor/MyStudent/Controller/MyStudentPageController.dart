import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Student.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class MyStudentPageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  List<Student> myStudent = [];
  bool isloadinggetmyStudent = false;
  Future<void> GetMyStudent(BuildContext context) async {
    isloadinggetmyStudent = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetMyStudent,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          myStudent.add(Student.fromJson(element));
        }
        isloadinggetmyStudent = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetmyStudent = false;
        notifyListeners();
      } else {
        isloadinggetmyStudent = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetmyStudent = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
