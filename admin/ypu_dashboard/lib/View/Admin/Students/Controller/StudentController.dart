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
import 'package:ypu_dashboard/Model/Student.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';

class StudentController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetStudent = false;
  List<Student> listStudent = [];
  List<Student> listStudentfilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  void searchStudent(String query) {
    filterStudent(query: query);
  }

  void filterStudent({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listStudentfilter = List.from(listStudent);
    } else {
      listStudentfilter = listStudent.where((student) {
        bool queryMatches = (student.specialization
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (student.registeredYear
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (student.universityNumber
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (student.user?.email?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (student.user?.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (student.user?.phone?.contains(query) ?? false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

  Future<Either<Failure, bool>> GetAllStudents(BuildContext context) async {
    listStudent.clear();
    isLoadinggetStudent = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllStudents,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var student in data['data']) {
          listStudent.add(Student.fromJson(student));
        }
        listStudentfilter = listStudent;
        isLoadinggetStudent = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetStudent = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetStudent = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetStudent = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<Either<Failure, bool>> AddStudents(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddStudents,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'password': passwordcontroller.text,
            'specialization': specializationcontroller.text,
            'registered_year': registeredYearcontroller.text,
            'university_number': universityNumbercontroller.text,
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
        GetAllStudents(context);
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
  TextEditingController specializationcontroller = TextEditingController();
  TextEditingController universityNumbercontroller = TextEditingController();
  TextEditingController registeredYearcontroller = TextEditingController();

  cleardata() {
    namecontroller.clear();
    emailcontroller.clear();
    phonecontroller.clear();
    passwordcontroller.clear();
    specializationcontroller.clear();
  }

  filldata(Student student) {
    namecontroller.text = student.user!.name!;
    emailcontroller.text = student.user!.email!;
    phonecontroller.text = student.user!.phone!;
    specializationcontroller.text = student.specialization!;
    registeredYearcontroller.text = student.registeredYear!.toString();
    universityNumbercontroller.text = student.universityNumber!;
  }

  DialogAddOrUpdateStudent(BuildContext context, {Student? student}) {
    final formkey = GlobalKey<FormState>();
    if (student != null) {
      filldata(student);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${student != null ? "Update" : "Add New"} Student"),
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
                      if (student == null) Gap(20),
                      if (student == null)
                        TextInputCustom(
                          controller: passwordcontroller,
                          hint: "Password",
                          icon: Icon(Icons.password),
                          ispassword: true,
                        ),
                      Gap(20),
                      TextInputCustom(
                        controller: specializationcontroller,
                        hint: "Specialization",
                        icon: Icon(Icons.workspace_premium),
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: registeredYearcontroller,
                        hint: "Registered Year",
                        icon: Icon(Icons.calendar_month),
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: universityNumbercontroller,
                        hint: "University Number",
                        icon: Icon(Icons.numbers),
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
                        if (student != null) {
                          result = await UpdateStudents(context, student.id!);
                        } else {
                          result = await AddStudents(context);
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
                        student != null ? "Update" : "Add",
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

  Future<Either<Failure, bool>> UpdateStudents(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateStudents(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'specialization': specializationcontroller.text,
            'registered_year': registeredYearcontroller.text,
            'university_number': universityNumbercontroller.text,
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
        GetAllStudents(context);
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

  Future<Either<Failure, bool>> DeleteStudents(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteStudents(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllStudents(context);
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

  DialogDeleteStudent(BuildContext context, Student Student) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Student"),
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
                      "Are you sure you want to delete the Student and its associated data?",
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
                          await DeleteStudents(context, Student.id!);
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
