// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:ypu_dashboard/Controller/ServicesProvider.dart';

enum RequestType { GET, POST, PUT, DELETE }

enum RequestTypeImage { POST_WITH_IMAGE, POST_WITH_MULTI_IMAGE }

class NetworkClient {
  static final String _baseUrl = AppApi.url;

  final Client _client;

  NetworkClient(this._client);
  Future<MultipartRequest> requestimage({
    required String path,
    Map<String, String>? body,
    http.MultipartFile? image,
  }) async {
    return http.MultipartRequest(
      "POST",
      Uri.parse('$_baseUrl$path'),
    )
      ..fields.addAll(body!)
      ..files.add(image!)
      ..headers.addAll(
        {
          "Accept": "application/json",
          'Authorization': 'Bearer ${ServicesProvider.getToken()}'
        },
      );
  }

  Logger logger = Logger();

  Future<Response> request(
      {required RequestType requestType,
      required String path,
      String? body,
      int TimeOut = 1000}) async {
    log("$_baseUrl$path");
    logger.d(ServicesProvider.getToken());

    switch (requestType) {
      case RequestType.GET:
        return _client.get(Uri.parse("$_baseUrl$path"), headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ServicesProvider.getToken()}'
        }).timeout(Duration(seconds: TimeOut));
      case RequestType.POST:
        return _client
            .post(Uri.parse("$_baseUrl$path"),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${ServicesProvider.getToken()}'
                },
                body: body)
            .timeout(Duration(seconds: TimeOut));
      case RequestType.PUT:
        return _client
            .put(Uri.parse("$_baseUrl$path"),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${ServicesProvider.getToken()}'
                },
                body: body)
            .timeout(Duration(seconds: TimeOut));
      case RequestType.DELETE:
        return _client
            .delete(Uri.parse("$_baseUrl$path"),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${ServicesProvider.getToken()}'
                },
                body: body)
            .timeout(Duration(seconds: TimeOut));
    }
  }
}
