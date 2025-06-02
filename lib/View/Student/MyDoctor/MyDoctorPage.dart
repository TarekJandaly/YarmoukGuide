import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Chat/ChatPage.dart';
import 'package:unity_test/View/Chat/Controller/ChatPageController.dart';
import 'package:unity_test/View/Student/MyDoctor/Controller/MyDoctorPageController.dart';

class MyDoctorPage extends StatelessWidget {
  const MyDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDoctorPageController>(
        builder: (context, controller, child) => Scaffold(
              appBar: AppBar(
                title: Text("My Student"),
              ),
              body: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.myDoctor.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.basic,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: AppColors.black.withAlpha(50),
                          offset: Offset(0, 3.5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.myDoctor[index].user!.name!,
                                  style: TextStyles.title,
                                ),
                                Text(
                                  controller.myDoctor[index].specialization!,
                                  style: TextStyles.inputtitle,
                                )
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () => CustomRoute.RouteTo(
                                  context,
                                  ChangeNotifierProvider(
                                    create: (context) => ChatPageController()
                                      ..CreateChat(
                                          controller.myDoctor[index].user!.id!),
                                    builder: (context, child) => ChatPage(
                                        controller.myDoctor[index].user!.name!),
                                  )),
                              child: Text("Chat"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
