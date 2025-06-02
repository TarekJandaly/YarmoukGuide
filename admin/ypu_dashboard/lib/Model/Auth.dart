class Auth {
  String? token;
  String? role;

  Auth({this.token, this.role});

  Auth.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    role = json['role'];
  }
}
