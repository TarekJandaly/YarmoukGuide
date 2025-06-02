// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Model/Doctor.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustom.dart';

class DoctorController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isLoadinggetDoctor = false;
  List<Doctor> listDoctor = [];
  List<Doctor> listdoctorfilter = [];
  TextEditingController searchcontroller = TextEditingController();
  Logger logger = Logger();
  void searchDoctor(String query) {
    filterDoctor(query: query);
  }

  void filterDoctor({String query = ""}) {
    if (query.isEmpty) {
      // إذا ما في بحث، رجع القائمة الأصلية
      listdoctorfilter = List.from(listDoctor);
    } else {
      listdoctorfilter = listDoctor.where((doctor) {
        bool queryMatches = (doctor.specialization
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (doctor.user?.email?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (doctor.user?.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (doctor.user?.phone?.contains(query) ?? false);

        return queryMatches;
      }).toList();
    }
    notifyListeners();
  }

  Future<Either<Failure, bool>> GetAllDoctors(BuildContext context) async {
    listDoctor.clear();
    isLoadinggetDoctor = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllDoctors,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var doctor in data['data']) {
          listDoctor.add(Doctor.fromJson(doctor));
        }
        listdoctorfilter = listDoctor;
        isLoadinggetDoctor = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetDoctor = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetDoctor = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetDoctor = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<Either<Failure, bool>> AddDoctors(BuildContext context) async {
    try {
      final response = await client.request(
        path: AppApi.AddDoctors,
        requestType: RequestType.POST,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'password': passwordcontroller.text,
            'specialization': specializationcontroller.text,
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
        GetAllDoctors(context);
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

  cleardata() {
    namecontroller.clear();
    emailcontroller.clear();
    phonecontroller.clear();
    passwordcontroller.clear();
    specializationcontroller.clear();
  }

  filldata(Doctor doctor) {
    namecontroller.text = doctor.user!.name!;
    emailcontroller.text = doctor.user!.email!;
    phonecontroller.text = doctor.user!.phone!;
    specializationcontroller.text = doctor.specialization;
  }

  DialogAddOrUpdateDoctor(BuildContext context, {Doctor? doctor}) {
    final formkey = GlobalKey<FormState>();
    if (doctor != null) {
      filldata(doctor);
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${doctor != null ? "Update" : "Add New"} Doctor"),
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
                      if (doctor == null) Gap(20),
                      if (doctor == null)
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
                        if (doctor != null) {
                          result = await UpdateDoctors(context, doctor.id!);
                        } else {
                          result = await AddDoctors(context);
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
                        doctor != null ? "Update" : "Add",
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

  Future<Either<Failure, bool>> UpdateDoctors(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.UpdateDoctors(id),
        requestType: RequestType.PUT,
        body: jsonEncode(
          {
            "name": namecontroller.text,
            'email': emailcontroller.text,
            'phone': phonecontroller.text,
            'specialization': specializationcontroller.text,
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
        GetAllDoctors(context);
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

  Future<Either<Failure, bool>> DeleteDoctors(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteDoctors(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomRoute.RoutePop(context);
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllDoctors(context);
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

  DialogDeleteDoctor(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete Doctor"),
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
                      "Are you sure you want to delete the Doctor and its associated data?",
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
                          await DeleteDoctors(context, doctor.id!);
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
