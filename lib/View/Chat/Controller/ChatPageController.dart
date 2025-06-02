import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_client/pusher_client.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Model/Chat.dart';
import 'package:unity_test/Model/Message.dart';
import 'package:unity_test/Services/NetworkClient.dart';

class ChatPageController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  Chat? chat;
  ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  List<Message> listmessage = [];
  int? usertwoid;
  late PusherClient pusher;
  Channel? channel;

  @override
  void dispose() {
    controller.dispose();
    pusher.disconnect();
    super.dispose();
  }

  void connectToPusher(String chatId) {
    pusher = PusherClient(
      "b72d47047d09c47cf7a1", // استبدله بمفتاح Pusher الخاص بك
      PusherOptions(
        cluster: "ap2", // استبدله بالقيمة الصحيحة

        encrypted: true,
      ),
      autoConnect: false,
    );

    pusher.connect();

    channel = pusher.subscribe("chat-$chatId");

    channel!.bind("new-message", (event) {
      if (event != null) {
        log(event.data!);
        final data = jsonDecode(event.data!);
        // log(data.toString());
        Message newMessage = Message.fromJson(data['message']);
        listmessage.insert(0, newMessage);
        notifyListeners();
        // scrollToBottom();
      }
    });
  }

  Future<void> SendMessage() async {
    try {
      final response = await client.request(
        requestType: RequestType.POST,
        path: AppApi.SendMessage,
        body: jsonEncode({
          'chat_id': chat!.id!.toString(),
          'message': controller.text.toString(),
        }),
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        await GetMessagesChat(chat!.id!);

        controller.clear();
        notifyListeners();
      } else {
        throw Exception('Failed to create conversation');
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> CreateChat(int touserid) async {
    try {
      final response = await client.request(
        requestType: RequestType.POST,
        path: AppApi.CreateChat,
        body: jsonEncode({'to': touserid.toString()}),
      );
      log(response.body);
      usertwoid = touserid;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        chat = Chat.fromJson(data);

        await GetMessagesChat(chat!.id!);
        // scrollToBottom();
        connectToPusher(chat!.id!.toString()); // الاتصال بـ Pusher
        notifyListeners();
      } else {
        throw Exception('Failed to create conversation');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> GetMessagesChat(int ChatId) async {
    listmessage.clear();
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: AppApi.GetMessagesChat(ChatId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        for (var element in data) {
          listmessage.add(Message.fromJson(element));
        }
        listmessage = listmessage.reversed.toList();
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
