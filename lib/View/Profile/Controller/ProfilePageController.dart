import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/Model/User.dart';
import 'package:unity_test/Services/CustomDialog.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:http/http.dart' as http;

class ProfilePageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController universitynumberController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  User user = User();
  filldata(User user) {
    namecontroller.text = user.name!;
    emailcontroller.text = user.email!;
    phonecontroller.text = user.phone!;
    if (ServicesProvider.getRole() == 'student' ||
        ServicesProvider.getRole() == 'doctor') {
      majorController.text = ServicesProvider.getRole() == 'student'
          ? user.student!.specialization!
          : user.doctor!.specialization!;
    }
    if (ServicesProvider.getRole() == 'student') {
      yearController.text = user.student!.registeredYear!.toString();
      universitynumberController.text = user.student!.universityNumber!;
    }
    if (ServicesProvider.getRole() == 'employee') {
      departmentController.text = user.employee!.department!;
    }
    notifyListeners();
  }

  bool isloadinggetprofile = false;
  Future<void> GetProfile(BuildContext context) async {
    isloadinggetprofile = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: ServicesProvider.getRole() == 'student'
            ? AppApi.GetProfileStudent
            : ServicesProvider.getRole() == 'doctor'
                ? AppApi.GetProfileDoctor
                : AppApi.GetProfileEmployee,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        user = User.fromJson(res['data']);
        filldata(user);
        isloadinggetprofile = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetprofile = false;
        notifyListeners();
      } else {
        isloadinggetprofile = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetprofile = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  XFile? imagesfile;
  ImagePicker picker = ImagePicker();

  Future pickimage(BuildContext context) async {
    try {
      imagesfile = await picker.pickImage(source: ImageSource.gallery);

      notifyListeners();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<Either<Failure, bool>> UpdateProfile(BuildContext context) async {
    try {
      // http.Response response;

      var response = await client.request(
        requestType: RequestType.POST,
        path: AppApi.UpdateProfile,
        body: jsonEncode({
          'name': namecontroller.text,
          'email': emailcontroller.text,
          'phone': phonecontroller.text,
        }),
        // file: await http.MultipartFile.fromPath(
        //   "profile_picture",
        //   imagesfile!.path,
        // ),
      );

      log(response.statusCode.toString());
      // String body = await response.stream.bytesToString();
      log(response.body);

      if (response.statusCode == 200) {
        GetProfile(context);
        // CustomRoute.RouteReplacementTo(
        //   context,
        //   ChangeNotifierProvider(
        //     create: (context) => LoginController(),
        //     lazy: true,
        //     builder: (context, child) => LoginPage(),
        //   ),
        // );
        CustomDialog.DialogSuccess(context,
            title: "Update Profile was successfully");
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

  Future<Either<Failure, bool>> UpdateImageProfile(BuildContext context) async {
    log(imagesfile!.path);
    try {
      var response = await client.requestwithfile(
        path: AppApi.UpdateImageProfile,
        file: await http.MultipartFile.fromPath(
          "profile_picture",
          imagesfile!.path,
        ),
      );

      log(response.statusCode.toString());
      String body = await response.stream.bytesToString();
      log(body);

      if (response.statusCode == 200) {
        GetProfile(context);
        imagesfile = null;

        CustomDialog.DialogSuccess(context,
            title: "Update Image Profile was successfully");
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
}
