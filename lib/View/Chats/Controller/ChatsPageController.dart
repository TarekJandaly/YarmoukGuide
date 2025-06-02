import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/ChatModel.dart';
import 'package:unity_test/Services/Failure.dart';
import 'package:unity_test/Services/NetworkClient.dart';
import 'package:http/http.dart' as http;

class ChatsPageController with ChangeNotifier {
  List<ChatModel> listchat = [];
  static NetworkClient client = NetworkClient(http.Client());

  Future<void> GetChats(BuildContext context) async {
    listchat.clear();
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetChats,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res) {
          listchat.add(ChatModel.fromJson(element));
        }
        notifyListeners();
        EasyLoading.dismiss();
      } else if (response.statusCode == 404) {
        EasyLoading.dismiss();
        EasyLoading.showError(ResultFailure('').message);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(ServerFailure().message);
      }
    } catch (e) {
      log(e.toString());
      log("error in this fun");
      EasyLoading.dismiss();
      EasyLoading.showError(GlobalFailure().message);
    }
  }
}
