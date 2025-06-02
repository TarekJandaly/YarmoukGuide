// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ypu_dashboard/Model/User.dart';

class Employee {
  var id;
  var userId;
  var department;
  var createdAt;
  var updatedAt;
  User? user;
  Employee(
      {this.id,
      this.userId,
      this.department,
      this.createdAt,
      this.updatedAt,
      this.user});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    department = json['department'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
