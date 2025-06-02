import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/View/Event/Controller/EventPageController.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventPageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(title: Text("Events")),
        body: ListView.builder(
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
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
                        event.title!,
                        style: TextStyles.title,
                      ),
                      Text(event.description!, style: TextStyles.inputtitle),
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
