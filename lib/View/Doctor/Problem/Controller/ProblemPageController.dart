import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:unity_test/Constant/colors.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Problem.dart';
import 'package:unity_test/Model/User.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:http/http.dart' as http;
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/Widgets/TextInput/TextInputCustom.dart';

class ProblemPageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetemployee = false;
  List<User> employees = [];
  Future<void> GetAllEmployee(BuildContext context) async {
    employees = [];
    isloadinggetemployee = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllEmployee,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          employees.add(User.fromJson(element));
        }
        isloadinggetemployee = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetemployee = false;
        notifyListeners();
      } else {
        isloadinggetemployee = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetemployee = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  bool isloadinggetproblem = false;
  List<Problem> problems = [];
  Future<void> GetAllProblems(BuildContext context) async {
    problems = [];
    isloadinggetproblem = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllProblems,
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

  TextEditingController descriptioncontroller = TextEditingController();
  Future<Either<Failure, bool>> SendProblem(BuildContext context) async {
    try {
      var response = await client.request(
        path: AppApi.SendProblem,
        requestType: RequestType.POST,
        body: jsonEncode({
          "description": descriptioncontroller.text,
          "employee_id": employee!.employee!.id
        }),
      );

      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 201) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "Problem sent successfully");
        GetAllProblems(context);
        return Right(true);
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

  DialogSendProblem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          actions: [
            ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  try {
                    var result = await SendProblem(context);
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
                child: Text("Send")),
            TextButton(
                onPressed: () => CustomRoute.RoutePop(context),
                child: Text("close")),
          ],
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInputCustom(
                  icon: Icon(Icons.bug_report),
                  controller: descriptioncontroller,
                  hint: "Write problem...",
                ),
                Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        // width: 100,
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
                        child: DropdownButtonFormField<User>(
                          isDense: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            fillColor: AppColors.basic,
                            labelText: 'Employee',
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
                          value: employee,
                          onChanged: (newValue) {
                            setState(
                              () {
                                employee = newValue!;
                              },
                            );
                          },
                          items: employees.map((employee) {
                            return DropdownMenuItem(
                              value: employee,
                              child: SizedBox(
                                width: 150,
                                height: 50,
                                child: Text(
                                  "${employee.name} (${employee.employee!.department})",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
