// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Model/Employee.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';

class EmployeeController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetEmployee = false;
  List<Employee> listEmployee = [];
  List<Employee> listEmployeefilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  void searchEmployee(String query) {
    filterEmployee(query: query);
  }

  void filterEmployee({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listEmployeefilter = List.from(listEmployee);
    } else {
      listEmployeefilter = listEmployee.where((employee) {
        bool queryMatches = (employee.department
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (employee.user?.email
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (employee.user?.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (employee.user?.phone?.contains(query) ?? false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

  Future<Either<Failure, bool>> GetAllEmployees(BuildContext context) async {
    listEmployee.clear();
    isLoadinggetEmployee = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllEmployees,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var employee in data['data']) {
          listEmployee.add(Employee.fromJson(employee));
        }
        listEmployeefilter = listEmployee;
        isLoadinggetEmployee = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetEmployee = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetEmployee = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetEmployee = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<Either<Failure, bool>> AddEmployees(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddEmployees,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'password': passwordcontroller.text,
            'department': departmentcontroller.text,
          },
        ),
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        CustomRoute.RoutePop(context);
        cleardata();
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllEmployees(context);
        return Right(true);
      } else if (response.statusCode == 404) {
        return Left(ResultFailure(''));
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();

  cleardata() {
    namecontroller.clear();
    emailcontroller.clear();
    phonecontroller.clear();
    passwordcontroller.clear();
    departmentcontroller.clear();
  }

  filldata(Employee employee) {
    namecontroller.text = employee.user!.name!;
    emailcontroller.text = employee.user!.email!;
    phonecontroller.text = employee.user!.phone!;
    departmentcontroller.text = employee.department!;
  }

  DialogAddOrUpdateEmployee(BuildContext context, {Employee? employee}) {
    final formkey = GlobalKey<FormState>();
    if (employee != null) {
      filldata(employee);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${employee != null ? "Update" : "Add New"} Employee"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextInputCustom(
                        controller: namecontroller,
                        hint: "Name",
                        icon: Icon(Icons.person),
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: emailcontroller,
                        hint: "Email",
                        icon: Icon(Icons.email),
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: phonecontroller,
                        hint: "Phone",
                        icon: Icon(Icons.phone),
                      ),
                      if (employee == null) Gap(20),
                      if (employee == null)
                        TextInputCustom(
                          controller: passwordcontroller,
                          hint: "Password",
                          icon: Icon(Icons.password),
                          ispassword: true,
                        ),
                      Gap(20),
                      TextInputCustom(
                        controller: departmentcontroller,
                        hint: "Department",
                        icon: Icon(Icons.workspace_premium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              GestureDetector(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      EasyLoading.show();
                      try {
                        Either<Failure, bool> result;
                        if (employee != null) {
                          result = await UpdateEmployees(context, employee.id!);
                        } else {
                          result = await AddEmployees(context);
                        }
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
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        employee != null ? "Update" : "Add",
                        style: TextStyles.button,
                      ),
                    ),
                  )),
              TextButton(
                onPressed: () {
                  CustomRoute.RoutePop(context);
                  cleardata();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Close",
                    style: TextStyles.pramed.copyWith(color: AppColors.primary),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<Either<Failure, bool>> UpdateEmployees(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateEmployees(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'department': departmentcontroller.text,
          },
        ),
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        cleardata();
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllEmployees(context);
        return Right(true);
      } else if (response.statusCode == 404) {
        CustomDialog.DialogError(context, title: "${data['message']}");
        return Right(true);
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<Either<Failure, bool>> DeleteEmployees(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteEmployees(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllEmployees(context);
        return Right(true);
      } else if (response.statusCode == 404) {
        CustomDialog.DialogError(context, title: "${data['message']}");
        return Right(true);
      } else {
        return Left(GlobalFailure());
      }
    } catch (e) {
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  DialogDeleteEmployee(BuildContext context, Employee Employee) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Employee"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to delete the Employee and its associated data?",
                      style: TextStyles.paraghraph,
                    )
                  ],
                ),
              ),
            ),
            actions: [
              GestureDetector(
                  onTap: () async {
                    EasyLoading.show();
                    try {
                      Either<Failure, bool> result =
                          await DeleteEmployees(context, Employee.id!);
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
                    decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Delete",
                        style: TextStyles.button,
                      ),
                    ),
                  )),
              TextButton(
                onPressed: () {
                  CustomRoute.RoutePop(context);
                  cleardata();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Close",
                    style: TextStyles.pramed.copyWith(color: AppColors.primary),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
