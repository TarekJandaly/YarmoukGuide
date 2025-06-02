// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ypu_dashboard/Model/User.dart';

class Doctor {
  var id;
  var userId;
  var specialization;
  var createdAt;
  var updatedAt;
  User? user;

  Doctor(
      {this.id,
      this.userId,
      this.specialization,
      this.createdAt,
      this.updatedAt,
      this.user});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    specialization = json['specialization'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
