import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Doctor.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class MyDoctorPageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  List<Doctor> myDoctor = [];
  bool isloadinggetmyDoctor = false;
  Future<void> GetStudentDoctors(BuildContext context) async {
    isloadinggetmyDoctor = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetStudentDoctors,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          myDoctor.add(Doctor.fromJson(element));
        }
        isloadinggetmyDoctor = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetmyDoctor = false;
        notifyListeners();
      } else {
        isloadinggetmyDoctor = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetmyDoctor = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
