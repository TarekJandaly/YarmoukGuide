// ignore_for_file: prefer_typing_uninitialized_variables

class Hall {
  var id;
  var name;
  var createdAt;
  var updatedAt;

  Hall({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Hall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
