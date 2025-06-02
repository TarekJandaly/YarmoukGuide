import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Hall.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class RoomControlller with ChangeNotifier {
  List<Hall> rooms = [];
  List<Hall> filteredRooms = [];
  Hall? selectedRoom;
  Set<Hall> activeRoutes = {}; // الغرف التي تم تفعيل المسار لها

  void filterRooms(String query) {
    filteredRooms = rooms
        .where((room) => room.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void toggleRouteActivation(BuildContext context, Hall room) {
    if (activeRoutes.contains(room)) {
      activeRoutes.remove(room);
      showSnackBar(context, 'Path to $room has been **deactivated**.');
    } else {
      activeRoutes.add(room);
      showSnackBar(context, 'Path to $room has been **activated**.');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showRoomInfo(BuildContext context, Hall room) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Room information: ${room.name}'),
          content: room.isHallOccupiedNow()
              ? Text('The room is currently occupied. Please try again later..')
              : Text('The room is not occupied.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Closing'),
            ),
          ],
        );
      },
    );
  }

  void showRoomOptions(BuildContext context, Hall room) {
    selectedRoom = room;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Options: $room',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  toggleRouteActivation(context, room);
                },
                icon: const Icon(Icons.map),
                label: Text(activeRoutes.contains(room)
                    ? 'Deactivate Path'
                    : 'Show on Map'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showRoomInfo(context, room);
                },
                icon: const Icon(Icons.info),
                label: const Text('View room information'),
              ),
            ],
          ),
        );
      },
    );
  }

  static NetworkClient client = NetworkClient(http.Client());
  bool isloadinggetroom = false;
  Future<void> GetAllRoom(BuildContext context) async {
    rooms = [];
    isloadinggetroom = true;
    notifyListeners();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetAllRoom,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        for (var element in res['data']) {
          rooms.add(Hall.fromJson(element));
        }
        isloadinggetroom = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        isloadinggetroom = false;
        notifyListeners();
      } else {
        isloadinggetroom = false;
        notifyListeners();
      }
    } catch (e) {
      isloadinggetroom = false;
      notifyListeners();
      log(e.toString());
      log("error in this fun");
    }
  }
}
