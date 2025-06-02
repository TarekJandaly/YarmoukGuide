import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_client/pusher_client.dart';
import 'package:geolocator/geolocator.dart';

class LocationController with ChangeNotifier {
  late PusherClient pusher;
  Channel? channel;
  double? latitude;
  double? longitude;

  // اتصال Pusher
  void connectToPusher() {
    pusher = PusherClient(
      "b72d47047d09c47cf7a1", // ضع مفتاح Pusher هنا
      PusherOptions(
        cluster: "ap2", // ضع الكلاستر الصحيح هنا
        encrypted: true,
      ),
      autoConnect: false,
    );

    // تحقق من حالة الاتصال
    pusher.onConnectionStateChange((state) {
      log("Connection state: ${state!.currentState}");
    });

    // بدء الاتصال
    pusher.connect();

    // الاشتراك في القناة
    channel = pusher.subscribe("location-updates");

    // الاستماع للحدث الذي يتم بثه
    channel!.bind("user-location-updated", (event) {
      if (event != null) {
        log("Location Update Received: ${event.data!}");
        final data = jsonDecode(event.data!);
        latitude = data['latitude'];
        longitude = data['longitude'];
        notifyListeners(); // تحديث واجهة المستخدم
      }
    });
  }

  // إرسال الموقع إلى الخادم
  Future<void> sendLocation(int userId) async {
    try {
      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // إرسال الإحداثيات إلى API
      final response = await http.post(
        Uri.parse("https://yourapi.com/api/update-location"),
        body: jsonEncode({
          'user_id': userId.toString(),
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Location sent successfully");
      } else {
        throw Exception('Failed to send location');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // إرسال الموقع بشكل دوري كل دقيقة (مثال)
  Future<void> sendLocationPeriodically(int userId) async {
    await Future.delayed(Duration(seconds: 5), () {
      sendLocation(userId); // إرسال الموقع بعد 5 ثوانٍ
    });
  }
}
