import 'package:unity_test/Model/User.dart';

class Doctor {
  int? id;
  int? userId;
  String? specialization;
  String? createdAt;
  String? updatedAt;
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
