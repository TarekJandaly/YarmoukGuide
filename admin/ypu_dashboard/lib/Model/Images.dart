class Images {
  int? id;
  String? path;
  String? createdAt;
  String? updatedAt;

  Images({this.id, this.path, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
