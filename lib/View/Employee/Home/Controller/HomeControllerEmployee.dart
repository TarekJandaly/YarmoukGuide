import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/User.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class HomeControllerEmployee with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  User user = User();
  bool isloadinggetprofile = false;
  Future<void> GetProfileEmployee(BuildContext context) async {
    isloadinggetprofile = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetProfileEmployee,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        user = User.fromJson(res['data']);
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
}
