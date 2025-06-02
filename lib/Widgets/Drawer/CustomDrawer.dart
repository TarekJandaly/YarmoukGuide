// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
// import 'package:unity_test/View/User/Body3DModel/Body3DModelPage.dart';
// import 'package:unity_test/View/User/Body3DModel/Controller/Body3DModelController.dart';
// import 'package:unity_test/View/User/Home/Controller/HomePageController.dart';
// import 'package:unity_test/View/User/Home/HomePage.dart';
// import 'package:unity_test/View/User/Profile/Controller/ProfileController.dart';
// import 'package:unity_test/View/User/Profile/ProfilePage.dart';
// import 'package:unity_test/View/User/RecommendWorkout/Controller/RecommendWorkoutController.dart';
// import 'package:unity_test/View/User/RecommendWorkout/RecommendWorkoutPage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.active,
              AppColors.basic,
              AppColors.basic,
              AppColors.basic,
              AppColors.basic,
              AppColors.basic,
              AppColors.basic,
              // AppColors.primary,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: ListView(
          children: [
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/PNG/Logo.png'),
            ),
            // if (ServicesProvider.getRole() != 'developer')
            //   ListTile(
            //     onTap: () => CustomRoute.RouteAndRemoveUntilTo(
            //         context,
            //         ChangeNotifierProvider(
            //           create: (context) =>
            //               HomePageController()..GetWorkout(context),
            //           builder: (context, child) =>
            //               SideBar(title: "Home Page", child: HomePage()),
            //         )),
            //     title: Text(
            //       "Home Page",
            //       style: TextStyles.pramed.copyWith(color: AppColors.primary),
            //     ),
            //     leading: SvgPicture.asset(
            //       'assets/SVG/home.svg',
            //       color: AppColors.primary,
            //     ),
            //   ),
            // if (ServicesProvider.getRole() != 'developer')
            //   ListTile(
            //     onTap: () => CustomRoute.RouteAndRemoveUntilTo(
            //         context,
            //         ChangeNotifierProvider(
            //           create: (context) => Body3DModelController()..initState(),
            //           builder: (context, child) =>
            //               SideBar(title: "3D Model", child: Body3DModelPage()),
            //         )),
            //     title: Text(
            //       "3D Model",
            //       style: TextStyles.pramed.copyWith(color: AppColors.primary),
            //     ),
            //     leading: SvgPicture.asset(
            //       'assets/SVG/model.svg',
            //       color: AppColors.primary,
            //     ),
            //   ),
            // if (ServicesProvider.getRole() != 'developer')
            //   ListTile(
            //     onTap: () => CustomRoute.RouteAndRemoveUntilTo(
            //         context,
            //         ChangeNotifierProvider(
            //           create: (context) => RecommendWorkoutController()
            //             ..GetRecommendWorkout(context),
            //           builder: (context, child) => SideBar(
            //               title: "Recommend Workout",
            //               child: RecommendWorkoutPage()),
            //         )),
            //     title: Text(
            //       "Recommend Workout",
            //       style: TextStyles.pramed.copyWith(color: AppColors.primary),
            //     ),
            //     leading: Icon(
            //       Icons.recommend,
            //       color: AppColors.primary,
            //     ),
            //   ),
            // if (ServicesProvider.getRole() != 'developer')
            // ListTile(
            //   onTap: () => CustomRoute.RouteAndRemoveUntilTo(
            //       context,
            //       ChangeNotifierProvider(
            //         create: (context) =>
            //             ProfileController()..GetProfile(context),
            //         builder: (context, child) =>
            //             SideBar(title: "Profile", child: ProfilePage()),
            //       )),
            //   title: Text(
            //     "Profile",
            //     style: TextStyles.pramed.copyWith(color: AppColors.primary),
            //   ),
            //   leading: SvgPicture.asset(
            //     'assets/SVG/profile.svg',
            //     color: AppColors.primary,
            //   ),
            // ),
            ListTile(
              onTap: () => ServicesProvider.logout(context),
              title: Text(
                "Logout",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: Icon(
                size: 20,
                Icons.logout_outlined,
                color: AppColors.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
