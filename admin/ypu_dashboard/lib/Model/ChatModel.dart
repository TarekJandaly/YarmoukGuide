class ChatModel {
  int? chatId;
  String? otherUser;
  int? otherUserId;
  String? createdAt;

  ChatModel({this.chatId, this.otherUser, this.otherUserId, this.createdAt});

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    otherUser = json['other_user'];
    otherUserId = json['other_user_id'];
    createdAt = json['created_at'];
  }
}
