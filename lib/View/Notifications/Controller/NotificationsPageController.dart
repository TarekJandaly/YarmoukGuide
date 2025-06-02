import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Notifications.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:http/http.dart' as http;

class NotificationsPageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetnotifications = false;
  List<Notifications> notifications = [];
  Future<void> GetNotifications(BuildContext context) async {
    notifications = [];
    isloadinggetnotifications = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetNotifications,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          notifications.add(Notifications.fromJson(element));
        }
        isloadinggetnotifications = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetnotifications = false;
        notifyListeners();
      } else {
        isloadinggetnotifications = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetnotifications = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
