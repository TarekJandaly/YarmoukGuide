class Problem {
  int? id;
  int? doctorId;
  int? employeeId;
  String? description;
  int? status;
  var createdAt;
  var updatedAt;

  Problem(
      {this.id,
      this.doctorId,
      this.employeeId,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  Problem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    employeeId = json['employee_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
