import 'package:unity_test/Model/Doctor.dart';
import 'package:unity_test/Model/Hall.dart';

class Course {
  int? id;
  String? name;
  String? code;
  int? hallId;
  String? day;
  String? time;
  String? time_end;
  int? maxStudents;
  String? type;
  var createdAt;
  var updatedAt;
  int? availableSlots;
  bool? canRegister;
  List<Doctor>? doctors;
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
      this.availableSlots,
      this.canRegister,
      this.doctors,
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
    availableSlots = json['available_slots'];
    canRegister = json['can_register'];
    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
    hall = json['hall'] != null ? Hall.fromJson(json['hall']) : null;
  }
}
