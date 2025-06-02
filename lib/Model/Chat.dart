// ignore_for_file: prefer_typing_uninitialized_variables

class Chat {
  int? id;
  int? userOne;
  var userTwo;
  String? createdAt;
  String? updatedAt;

  Chat({this.id, this.userOne, this.userTwo, this.createdAt, this.updatedAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userOne = json['user_one'];
    userTwo = json['user_two'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
