import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/Controller/ServicesProvider.dart';
import 'package:ypu_dashboard/Model/Images.dart';
import 'package:ypu_dashboard/Services/CustomDialog.dart';
import 'package:ypu_dashboard/Services/Failure.dart';
import 'package:ypu_dashboard/Services/NetworkClient.dart';

class MapController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  PlatformFile? pickedFile;
  List<PlatformFile> pickedimages = [];
  bool isUploading = false;
  bool isUploadingimage = false;

  String? jsonFilePath;
  String? mapImageUrl;

  Logger logger = Logger();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['dxf', 'jpg', 'jpeg', 'png', 'gif'],
    );

    if (result != null) {
      pickedFile = result.files.single;
      jsonFilePath = null;
      notifyListeners();
    }
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpeg', 'png', 'jpg', 'gif']);
    if (result != null) {
      pickedimages = result.files;
      notifyListeners();
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (pickedFile == null) {
      CustomDialog.DialogError(context, title: "Please select a file first.");
      return;
    }

    isUploading = true;
    notifyListeners();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppApi.url}/uploadAndConvertMap'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ServicesProvider.getToken()}',
    });

    if (pickedFile!.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'map_file',
          pickedFile!.bytes!,
          filename: pickedFile!.name,
        ),
      );
    }

    request.fields['name'] = 'Building Map';

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      logger.d(responseBody);

      var jsonResponse = json.decode(responseBody);

      if (response.statusCode == 201) {
        if (jsonResponse.containsKey('json_path')) {
          jsonFilePath = jsonResponse['json_path'];
        }

        notifyListeners();
        CustomDialog.DialogSuccess(context,
            title: "File uploaded successfully!");
      } else {
        CustomDialog.DialogError(context,
            title: "Failed to upload file. Status: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog.DialogError(context, title: "Error: $e");
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void showFilePath(BuildContext context) {
    if (jsonFilePath == null) {
      CustomDialog.DialogError(context, title: "No file path available.");
      return;
    }

    notifyListeners();
  }

  void viewMap() {}

  List<Images> listImages = [];
  bool isLoadinggetImages = false;
  Future<Either<Failure, bool>> GetAllImages(BuildContext context) async {
    listImages.clear();
    isLoadinggetImages = true;
    notifyListeners();
    try {
      final response = await client.request(
        path: AppApi.GetAllImages,
        requestType: RequestType.GET,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        for (var image in data['data']) {
          listImages.add(Images.fromJson(image));
        }
        isLoadinggetImages = false;
        notifyListeners();
        return Right(true);
      } else if (response.statusCode == 404) {
        isLoadinggetImages = false;
        notifyListeners();
        return Left(ResultFailure(''));
      } else {
        isLoadinggetImages = false;
        notifyListeners();
        return Left(GlobalFailure());
      }
    } catch (e) {
      isLoadinggetImages = false;
      notifyListeners();
      logger.d(e.toString());
      logger.d("error in this fun");
      return Left(GlobalFailure());
    }
  }

  Future<void> uploadimages(BuildContext context) async {
    if (pickedimages.isEmpty) {
      CustomDialog.DialogError(context, title: "Please select a file first.");
      return;
    }

    isUploadingimage = true;
    notifyListeners();
    var request = http.MultipartRequest(
        'POST', Uri.parse('${AppApi.url}${AppApi.AddImages}'));
    request.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ServicesProvider.getToken()}'
    });
    if (pickedimages.isNotEmpty) {
      for (var image in pickedimages) {
        request.files.add(http.MultipartFile.fromBytes(
          'images[]',
          image.bytes!,
          filename: image.name,
        ));
      }
    }

    try {
      var response = await request.send();
      logger.d(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        CustomDialog.DialogSuccess(context,
            title: "Images uploaded successfully!");
        pickedimages = [];
        GetAllImages(context);
        notifyListeners();
      } else {
        CustomDialog.DialogError(context, title: "Failed to upload images.");
      }
    } catch (e) {
      CustomDialog.DialogError(context, title: "Error: $e");
    } finally {
      isUploadingimage = false;
      notifyListeners();
    }
  }

  Future<Either<Failure, bool>> DeleteImages(
      BuildContext context, int id) async {
    try {
      final response = await client.request(
        path: AppApi.DeleteImages(id),
        requestType: RequestType.DELETE,
      );
      logger.d(response.statusCode.toString());
      logger.d(response.body.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomDialog.DialogSuccess(context, title: "${data['message']}");
        GetAllImages(context);
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
}
