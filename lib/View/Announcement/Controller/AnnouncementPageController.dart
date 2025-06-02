import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Announcement.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class AnnouncementPageController with ChangeNotifier {
  List<Announcement> announcements = [];

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetannouncements = false;
  Future<void> GetAllAnnouncements(BuildContext context) async {
    announcements = [];
    isloadinggetannouncements = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllAnnouncements,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          announcements.add(Announcement.fromJson(element));
        }
        isloadinggetannouncements = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetannouncements = false;
        notifyListeners();
      } else {
        isloadinggetannouncements = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetannouncements = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
