import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Problem.dart';
import 'package:unity_test/Model/User.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:http/http.dart' as http;

class ProblemPageEmployeeController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetproblem = false;
  List<Problem> problems = [];
  Future<void> GetMyProblems(BuildContext context) async {
    problems = [];
    isloadinggetproblem = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetMyProblems,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          problems.add(Problem.fromJson(element));
        }
        isloadinggetproblem = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetproblem = false;
        notifyListeners();
      } else {
        isloadinggetproblem = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetproblem = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  Future<Either<Failure, bool>> FinishProblem(
      BuildContext context, int id) async {
    try {
      var response = await client.request(
        path: AppApi.FinishProblem(id),
        requestType: RequestType.POST,
      );

      log(response.statusCode.toString());
      log(response.body);
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomDialog.DialogSuccess(context,
            title: "Problem finished successfully");
        GetMyProblems(context);
        return Right(true);
      } else if (response.statusCode == 403) {
        CustomDialog.DialogWarning(context, title: res['message']);
        return Left(ResultFailure(''));
      } else if (response.statusCode == 404) {
        return Left(ResultFailure(''));
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      log(e.toString());
      log("error in this fun");
      return Left(GlobalFailure());
    }
  }

  User? employee;
}
