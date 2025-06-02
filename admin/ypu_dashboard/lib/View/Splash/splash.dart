// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/View/Splash/Controller/SplashController.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, value, child) => Scaffold(
        body: SafeArea(
          child: Align(
            alignment: AlignmentDirectional.center,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.beat(
                      color: AppColors.primary, size: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
