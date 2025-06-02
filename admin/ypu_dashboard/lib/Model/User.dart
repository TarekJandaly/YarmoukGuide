// ignore_for_file: prefer_typing_uninitialized_variables

class User {
  var id;
  var name;
  var email;
  var phone;
  var deviceToken;
  var role;
  var xLocation;
  var yLocation;
  var zLocation;
  var profilePicture;
  var createdAt;
  var updatedAt;
  // Student? student;
  // Doctor? doctor;
  // Employee? employee;
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.deviceToken,
    this.role,
    this.xLocation,
    this.yLocation,
    this.zLocation,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    // this.student,
    // this.doctor,
    // this.employee
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    role = json['role'];
    xLocation = json['x_location'];
    yLocation = json['y_location'];
    zLocation = json['z_location'];
    profilePicture = json['profile_picture'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // student =
    //     json['student'] != null ? new Student.fromJson(json['student']) : null;
    // doctor =
    //     json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    // employee = json['employee'] != null
    //     ? new Employee.fromJson(json['employee'])
    //     : null;
  }
}
