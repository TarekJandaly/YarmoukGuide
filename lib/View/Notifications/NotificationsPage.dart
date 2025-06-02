import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/View/Notifications/Controller/NotificationsPageController.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsPageController>(
      builder: (context, controller, child) => Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.notifications.length,
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
                            controller.notifications[index].message!,
                            style: TextStyles.title,
                          ),
                          Text(
                            DateFormat("yyyy-MM-dd HH:mm a").format(
                                DateTime.parse(
                                    controller.notifications[index].date!)),
                            style: TextStyles.inputtitle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
