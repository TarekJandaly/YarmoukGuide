// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Model/Course.dart';
import 'package:ypu_dashboard/Model/Exam.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';

class ExamController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetExam = false;
  List<Exam> listExam = [];
  List<Exam> listExamfilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  bool isLoadinggetCourse = false;
  List<Course> listCourse = [];

  Future<Either<Failure, bool>> GetAllCourses(BuildContext context) async {
    listCourse.clear();
    isLoadinggetCourse = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllCourses,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var course in data['data']) {
          listCourse.add(Course.fromJson(course));
        }
        isLoadinggetCourse = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetCourse = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetCourse = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetCourse = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  void searchExam(String query) {
    filterExam(query: query);
  }

  void filterExam({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listExamfilter = List.from(listExam);
    } else {
      listExamfilter = listExam.where((exam) {
        bool queryMatches = (exam.course!.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (exam.examDate
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (exam.examTime
                    ?.toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

  Future<Either<Failure, bool>> GetAllExams(BuildContext context) async {
    listExam.clear();
    isLoadinggetExam = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllExams,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var exam in data['data']) {
          listExam.add(Exam.fromJson(exam));
        }
        listExamfilter = listExam;
        isLoadinggetExam = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetExam = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetExam = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetExam = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<Either<Failure, bool>> AddExams(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddExams,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "course_id": course!.id.toString(),
            'exam_time': formatTime(exam_time),
            'exam_date': exam_date.toString(),
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
        GetAllExams(context);
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

  Course? course;
  DateTime exam_date = DateTime.now();
  TimeOfDay exam_time = TimeOfDay.now();

  TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(':'); // [08, 00, 00]
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  cleardata() {
    course = null;
    exam_date = DateTime.now();
    exam_time = TimeOfDay.now();
  }

  filldata(Exam exam) {
    course = listCourse.where((element) => element.id == exam.course!.id).first;
    exam_date = DateTime.parse(exam.examDate!);
    exam_time = parseTime(exam.examTime!);
  }

  changecourse(value) {
    course = value;
  }

  Future<void> selectTime(BuildContext context, Function setState) async {
    TimeOfDay? pickedDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null) {
      setState(() {
        exam_time = pickedDate;
      });
    }
  }

  Future<void> selectDate(BuildContext context, Function setState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2070),
    );

    if (pickedDate != null) {
      setState(() {
        exam_date = pickedDate;
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // الثواني 00 دائمًا
  }

  DialogAddOrUpdateExam(BuildContext context, {Exam? exam}) {
    final formkey = GlobalKey<FormState>();
    if (exam != null) {
      filldata(exam);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${exam != null ? "Update" : "Add New"} Exam"),
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
                      Container(
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
                        child: DropdownButtonFormField<Course>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            isDense: true,
                            fillColor: AppColors.basic,
                            labelText: 'Course',
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
                          value: course,
                          onChanged: (newValue) {
                            changecourse(newValue);
                          },
                          items: listCourse.map((course) {
                            return DropdownMenuItem(
                              value: course,
                              child: Text(course.name),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(20),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => selectDate(context, setState),
                              child: Text("Select Date")),
                          Gap(10),
                          Expanded(
                              child: Text(
                                  DateFormat('yyy-MM-dd').format(exam_date))),
                        ],
                      ),
                      Gap(20),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => selectTime(context, setState),
                              child: Text("Select start time")),
                          Gap(10),
                          Expanded(child: Text(formatTime(exam_time))),
                        ],
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
                        if (exam != null) {
                          result = await UpdateExams(context, exam.id!);
                        } else {
                          result = await AddExams(context);
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
                        exam != null ? "Update" : "Add",
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

  Future<Either<Failure, bool>> UpdateExams(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateExams(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "course_id": course!.id.toString(),
            'exam_time': formatTime(exam_time),
            'exam_date': exam_date.toString(),
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
        GetAllExams(context);
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

  Future<Either<Failure, bool>> DeleteExams(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteExams(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllExams(context);
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

  DialogDeleteExam(BuildContext context, Exam Exam) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Exam"),
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
                      "Are you sure you want to delete the Exam and its associated data?",
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
                          await DeleteExams(context, Exam.id!);
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
