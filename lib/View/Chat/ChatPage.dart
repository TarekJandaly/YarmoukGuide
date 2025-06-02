// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/View/Chat/Controller/ChatPageController.dart';

class ChatPage extends StatelessWidget {
  ChatPage(this.chatname);
  String? chatname;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatPageController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(title: Text(chatname!)),
          resizeToAvoidBottomInset: true, // يسمح برفع المحتوى عند ظهور الكيبورد
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  // dragStartBehavior: DragStartBehavior.start,
                  controller: controller.scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  reverse: true,
                  itemCount: controller.listmessage.length,
                  itemBuilder: (context, index) {
                    var message = controller.listmessage[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Align(
                        alignment: message.senderId!.toString() ==
                                controller.usertwoid.toString()
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.senderId.toString() ==
                                    controller.usertwoid.toString()
                                ? AppColors.secondery
                                : AppColors.active,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.message!,
                            style: TextStyle(color: AppColors.basic),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.controller,
                          decoration: InputDecoration(
                            hintText: "Type message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onSubmitted: (value) {
                            controller.SendMessage();
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: AppColors.active),
                        onPressed: () {
                          controller.SendMessage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
