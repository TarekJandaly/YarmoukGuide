// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Model/Hall.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';

class HallController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetHall = false;
  List<Hall> listHall = [];
  List<Hall> listHallfilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  void searchHall(String query) {
    filterHall(query: query);
  }

  void filterHall({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listHallfilter = List.from(listHall);
    } else {
      listHallfilter = listHall.where((hall) {
        bool queryMatches =
            (hall.name?.toLowerCase().contains(query.toLowerCase()) ?? false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

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
        listHallfilter = listHall;
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

  Future<Either<Failure, bool>> AddHalls(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddHalls,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "name": namecontroller.text,
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
        GetAllHalls(context);
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

  cleardata() {
    namecontroller.clear();
  }

  filldata(Hall hall) {
    namecontroller.text = hall.name!;
  }

  DialogAddOrUpdateHall(BuildContext context, {Hall? hall}) {
    final formkey = GlobalKey<FormState>();
    if (hall != null) {
      filldata(hall);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${hall != null ? "Update" : "Add New"} Hall"),
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
                        icon: Icon(Icons.room),
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
                        if (hall != null) {
                          result = await UpdateHalls(context, hall.id!);
                        } else {
                          result = await AddHalls(context);
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
                        hall != null ? "Update" : "Add",
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

  Future<Either<Failure, bool>> UpdateHalls(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateHalls(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "name": namecontroller.text,
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
        GetAllHalls(context);
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

  Future<Either<Failure, bool>> DeleteHalls(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteHalls(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllHalls(context);
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

  DialogDeleteHall(BuildContext context, Hall Hall) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Hall"),
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
                      "Are you sure you want to delete the Hall and its associated data?",
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
                          await DeleteHalls(context, Hall.id!);
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
