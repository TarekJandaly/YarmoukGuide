class Employee {
  int? id;
  int? userId;
  String? department;
  String? createdAt;
  String? updatedAt;

  Employee(
      {this.id, this.userId, this.department, this.createdAt, this.updatedAt});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    department = json['department'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
