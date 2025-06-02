// ignore_for_file: prefer_typing_uninitialized_variables

class Message {
  var id;
  var chatId;
  var senderId;
  String? message;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
      this.chatId,
      this.senderId,
      this.message,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    message = json['message'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
