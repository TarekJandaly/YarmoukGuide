class Notifications {
  int? id;
  int? userId;
  String? message;
  String? date;
  String? createdAt;
  String? updatedAt;

  Notifications(
      {this.id,
      this.userId,
      this.message,
      this.date,
      this.createdAt,
      this.updatedAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
