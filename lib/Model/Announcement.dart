class Announcement {
  int? id;
  String? title;
  String? description;
  String? image;
  var createdAt;
  var updatedAt;

  Announcement(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.createdAt,
      this.updatedAt});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
