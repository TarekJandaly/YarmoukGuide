import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/User.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class MapController with ChangeNotifier {
  bool is3DView = false;
  bool isLoadingUsers = false;
  List<User> users = [];
  List<User> filteredUsers = [];
  String? selectedUser;

  void toggleMapView() {
    is3DView = !is3DView;
    notifyListeners();
  }

  void filterUsers(String query) {
    filteredUsers = users
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void selectUser(String name) {
    selectedUser = name;
    notifyListeners();
  }

  void showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('View 2D map'),
              onTap: () {
                Navigator.pop(context);
                if (is3DView) {
                  toggleMapView();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.threed_rotation),
              title: const Text('View 3D map'),
              onTap: () {
                Navigator.pop(context);
                if (!is3DView) {
                  toggleMapView();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showUserOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User: ${selectedUser}"),
          content: const Text("Choose an action"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Showing path to ${selectedUser}")),
                );
              },
              child: const Text("Show Path"),
            ),
          ],
        );
      },
    );
  }

  Future<void> scanImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final extractedNumbers = _extractNumbers(recognizedText.text);

    if (extractedNumbers.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Scanning successful! Number: $extractedNumbers')),
      );
    } else {
      showScanErrorPopup(context);
    }
  }

  String _extractNumbers(String text) {
    final RegExp regex = RegExp(r'\d+');
    final matches = regex
        .allMatches(text)
        .map((m) => m.group(0))
        .whereType<String>()
        .toList();
    return matches.isNotEmpty ? matches.join(", ") : "";
  }

  void showScanErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanning Failed'),
          content: const Text('Please try scanning again properly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  showusersdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select a User"),
          content: SizedBox(
            width: double.maxFinite,
            child: isLoadingUsers
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Search user...",
                        ),
                        onChanged: (query) {
                          filterUsers(query);
                        },
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(users[index].name!),
                              subtitle: Text(
                                  users[index].student?.universityNumber! ??
                                      ''),
                              onTap: () {
                                selectUser(users[index].name!);
                                Navigator.pop(context);
                                showUserOptionsDialog(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetuser = false;
  Future<void> GetStudentsAndDoctors(BuildContext context) async {
    isloadinggetuser = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetStudentsAndDoctors,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          users.add(User.fromJson(element));
        }
        isloadinggetuser = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetuser = false;
        notifyListeners();
      } else {
        isloadinggetuser = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetuser = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }

  Future<void> UpdateUserLocation(
      var x_location, var y_location, var z_loaction) async {
    isloadinggetuser = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.POST,
        path: AppApi.UpdateUserLocation,
        body: jsonEncode({
          "x_location": x_location.toString(),
          "y_location": y_location.toString(),
          "z_location": z_loaction.toString(),
        }),
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        isloadinggetuser = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetuser = false;
        notifyListeners();
      } else {
        isloadinggetuser = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetuser = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
