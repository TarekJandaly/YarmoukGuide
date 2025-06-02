import 'dart:developer';

import 'package:unity_test/Model/Course.dart';

class Hall {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<Course>? courses;

  Hall({this.id, this.name, this.createdAt, this.updatedAt, this.courses});

  Hall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['courses'] != null) {
      courses = <Course>[];
      json['courses'].forEach((v) {
        courses!.add(new Course.fromJson(v));
      });
    }
  }
// تحقق إذا كانت القاعة تحتوي على محاضرة في الوقت الفعلي
  bool isHallOccupiedNow() {
    DateTime now = DateTime.now(); // الوقت الحالي بتاريخ اليوم

    for (var course in courses!) {
      // تحويل وقت البداية ووقت النهاية إلى DateTime مع تاريخ اليوم
      DateTime startTime = _parseTime(course.time!);
      DateTime endTime = _parseTime(course.time_end!);

      log("Current Time: $now");
      log("Start Time: $startTime");
      log("End Time: $endTime");

      // التحقق إذا كان الوقت الحالي بين وقت البداية والنهاية
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        return true; // القاعة مشغولة
      }
    }
    return false; // القاعة غير مشغولة
  }

  // تحويل الوقت من صيغة string إلى DateTime مع تاريخ اليوم
  DateTime _parseTime(String time) {
    DateTime now = DateTime.now(); // الحصول على تاريخ اليوم
    List<String> timeParts =
        time.split(":"); // تقسيم الوقت إلى ساعات ودقائق وثواني

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]), // ساعة
      int.parse(timeParts[1]), // دقيقة
      int.parse(timeParts[2]), // ثانية
    );
  }
}
