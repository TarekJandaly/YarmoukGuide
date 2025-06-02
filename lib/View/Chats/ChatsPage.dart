import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Chat/ChatPage.dart';
import 'package:unity_test/View/Chat/Controller/ChatPageController.dart';
import 'package:unity_test/View/Chats/Controller/ChatsPageController.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsPageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        body: controller.listchat.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      size: 80.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "No Chats",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: controller.listchat.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    CustomRoute.RouteTo(
                        context,
                        ChangeNotifierProvider(
                          create: (context) => ChatPageController()
                            ..CreateChat(
                                controller.listchat[index].otherUserId!),
                          builder: (context, child) =>
                              ChatPage(controller.listchat[index].otherUser),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      // width: 200,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(100),
                              offset: Offset(0, 0),
                              blurRadius: 7),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.active),
                        color: AppColors.basic,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat,
                              color: Colors.grey,
                              size: 35,
                            ),
                            Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.listchat[index].otherUser}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "${DateFormat('yyyy-MM-dd').format(DateTime.parse(controller.listchat[index].createdAt!))}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color:
                                          AppColors.secondery.withAlpha(100)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
