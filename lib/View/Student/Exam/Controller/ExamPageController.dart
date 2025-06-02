import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Exam.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class ExamPageController with ChangeNotifier {
  List<Exam> exames = [];

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetexam = false;
  Future<void> GetAllExamsStudent(BuildContext context) async {
    exames = [];
    isloadinggetexam = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllExamsStudent,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          exames.add(Exam.fromJson(element));
        }
        isloadinggetexam = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetexam = false;
        notifyListeners();
      } else {
        isloadinggetexam = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetexam = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
