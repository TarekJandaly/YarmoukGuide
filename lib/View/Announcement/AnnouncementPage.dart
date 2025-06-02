import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/View/Announcement/Controller/AnnouncementPageController.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementPageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(title: Text("Announcements")),
        body: ListView.builder(
          itemCount: controller.announcements.length,
          itemBuilder: (context, index) {
            final announcement = controller.announcements[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title!,
                        style: TextStyles.title,
                      ),
                      Text(announcement.description!,
                          style: TextStyles.inputtitle),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
