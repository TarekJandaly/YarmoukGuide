import 'package:flutter/material.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/Services/Responsive.dart';
import 'package:unity_test/Widgets/Drawer/CustomDrawer.dart';

// ignore: must_be_immutable
class SideBar extends StatelessWidget {
  SideBar({this.child, this.title});

  Widget? child;
  String? title;

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = Responsive.getWidth(context) > 800;
    return Scaffold(
        drawer: CustomDrawer(),
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
