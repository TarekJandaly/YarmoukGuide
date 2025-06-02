import 'package:flutter/material.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Services/Responsive.dart';
import 'package:ypu_dashboard/View/Widgets/Drawer/CustomDrawer.dart';

// ignore: must_be_immutable
class SideBar extends StatelessWidget {
  SideBar({this.child, this.title});

  Widget? child;
  String? title;

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = Responsive.getWidth(context) > 800;

    return Scaffold(
        drawer: isLargeScreen ? null : CustomDrawer(),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          backgroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 75,
          centerTitle: true,
          title: Text(
            title!,
            style: TextStyles.header.copyWith(color: AppColors.basic),
          ),
        ),
        body: Row(
          children: [
            if (isLargeScreen) CustomDrawer(),
            Expanded(child: child!)
          ],
        ));
  }
}
