// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ypu_dashboard/Model/Hall.dart';

class Course {
  var id;
  var name;
  var code;
  var hallId;
  var day;
  var time;
  var time_end;
  var maxStudents;
  var type;
  var createdAt;
  var updatedAt;
  Hall? hall;
  Course(
      {this.id,
      this.name,
      this.code,
      this.hallId,
      this.day,
      this.time,
      this.time_end,
      this.maxStudents,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.hall});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    hallId = json['hall_id'];
    day = json['day'];
    time = json['time'];
    time_end = json['time_end'];
    maxStudents = json['max_students'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hall = json['hall'] != null ? Hall.fromJson(json['hall']) : null;
  }
}
