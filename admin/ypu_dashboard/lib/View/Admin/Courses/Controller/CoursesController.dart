// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/lists.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Model/Course.dart';
import 'package:ypu_dashboard/Model/Hall.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';

class CourseController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetCourse = false;
  List<Course> listCourse = [];
  List<Course> listCoursefilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  bool isLoadinggetHall = false;
  List<Hall> listHall = [];

  Future<Either<Failure, bool>> GetAllHalls(BuildContext context) async {
    listHall.clear();
    isLoadinggetHall = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllHalls,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var hall in data['data']) {
          listHall.add(Hall.fromJson(hall));
        }
        isLoadinggetHall = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetHall = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetHall = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetHall = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  void searchCourse(String query) {
    filterCourse(query: query);
  }

  void filterCourse({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listCoursefilter = List.from(listCourse);
    } else {
      listCoursefilter = listCourse.where((course) {
        bool queryMatches = (course.code
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (course.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (course.day
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (course.hall?.name
                    ?.toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (course.maxStudents
                    ?.toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (course.time?.toString().contains(query) ?? false) ||
            (course.time_end?.toString().contains(query) ?? false) ||
            (course.type?.toString().contains(query) ?? false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

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
        listCoursefilter = listCourse;
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

  Future<Either<Failure, bool>> AddCourses(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddCourses,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'code': codecontroller.text,
            'day': day,
            'hall_id': hall!.id,
            'time': formatTime(time),
            'time_end': formatTime(time_end),
            'max_students': maxStudentscontroller.text,
            'type': type,
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
        GetAllCourses(context);
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
  TextEditingController codecontroller = TextEditingController();
  Hall? hall;
  String? day;
  TimeOfDay? time;
  TimeOfDay? time_end;
  TextEditingController maxStudentscontroller = TextEditingController();
  String? type;

  TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(':'); // [08, 00, 00]
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  cleardata() {
    namecontroller.clear();
  }

  filldata(Course course) {
    namecontroller.text = course.name!;
    codecontroller.text = course.code;
    day = course.day;
    hall = listHall.where((element) => element.id == course.hall!.id).first;
    course.hall!;
    time = parseTime(course.time);
    time_end = parseTime(course.time_end);
    maxStudentscontroller.text = course.maxStudents.toString();
    type = course.type;
  }

  changeday(value) {
    day = value;
  }

  changetype(value) {
    type = value;
  }

  changehall(value) {
    hall = value;
  }

  Future<void> selectTime(
      BuildContext context, bool isStartDate, Function setState) async {
    TimeOfDay? pickedDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          time = pickedDate;
        } else {
          time_end = pickedDate;
        }
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // الثواني 00 دائمًا
  }

  DialogAddOrUpdateCourse(BuildContext context, {Course? course}) {
    final formkey = GlobalKey<FormState>();
    if (course != null) {
      filldata(course);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${course != null ? "Update" : "Add New"} Course"),
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
                        icon: Icon(Icons.grade),
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: codecontroller,
                        hint: "Code",
                        icon: Icon(Icons.numbers),
                      ),
                      Gap(20),
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            isDense: true,
                            fillColor: AppColors.basic,
                            labelText: 'Day',
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
                          value: day,
                          onChanged: (newValue) {
                            changeday(newValue);
                          },
                          items: days.map((day) {
                            return DropdownMenuItem(
                              value: day,
                              child: Text(day),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(20),
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
                        child: DropdownButtonFormField<Hall>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.door_back_door),
                            isDense: true,
                            fillColor: AppColors.basic,
                            labelText: 'Hall',
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
                          value: hall,
                          onChanged: (newValue) {
                            changehall(newValue);
                          },
                          items: listHall.map((hall) {
                            return DropdownMenuItem(
                              value: hall,
                              child: Text(hall.name),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(20),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () =>
                                  selectTime(context, true, setState),
                              child: Text("Select start time")),
                          Gap(10),
                          Expanded(child: Text(formatTime(time))),
                        ],
                      ),
                      Gap(20),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () =>
                                  selectTime(context, false, setState),
                              child: Text("Select end time")),
                          Gap(10),
                          Expanded(child: Text(formatTime(time_end))),
                        ],
                      ),
                      Gap(20),
                      TextInputCustom(
                        controller: maxStudentscontroller,
                        hint: "Max Students",
                        icon: Icon(Icons.group),
                      ),
                      Gap(20),
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.type_specimen),
                            isDense: true,
                            fillColor: AppColors.basic,
                            labelText: 'Type',
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
                          value: type,
                          onChanged: (newValue) {
                            changetype(newValue);
                          },
                          items: typecourse.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                        ),
                      )
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
                        if (course != null) {
                          result = await UpdateCourses(context, course.id!);
                        } else {
                          result = await AddCourses(context);
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
                        course != null ? "Update" : "Add",
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

  Future<Either<Failure, bool>> UpdateCourses(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateCourses(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'code': codecontroller.text,
            'day': day,
            'hall_id': hall!.id,
            'time': formatTime(time),
            'time_end': formatTime(time_end),
            'max_students': maxStudentscontroller.text,
            'type': type,
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
        GetAllCourses(context);
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

  Future<Either<Failure, bool>> DeleteCourses(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteCourses(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllCourses(context);
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

  DialogDeleteCourse(BuildContext context, Course Course) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Course"),
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
                      "Are you sure you want to delete the Course and its associated data?",
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
                          await DeleteCourses(context, Course.id!);
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
