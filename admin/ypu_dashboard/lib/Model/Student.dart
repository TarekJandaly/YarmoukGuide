import 'package:ypu_dashboard/Model/User.dart';

class Student {
  int? id;
  int? userId;
  String? universityNumber;
  int? registeredYear;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  User? user;

  Student(
      {this.id,
      this.userId,
      this.universityNumber,
      this.registeredYear,
      this.specialization,
      this.createdAt,
      this.updatedAt,
      this.user});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    universityNumber = json['university_number'];
    registeredYear = json['registered_year'];
    specialization = json['specialization'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
