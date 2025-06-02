import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Event.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class EventPageController with ChangeNotifier {
  List<Event> events = [];

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetevent = false;
  Future<void> GetAllEvent(BuildContext context) async {
    events = [];
    isloadinggetevent = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllEvent,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          events.add(Event.fromJson(element));
        }
        isloadinggetevent = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetevent = false;
        notifyListeners();
      } else {
        isloadinggetevent = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetevent = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
