import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/View/Doctor/Home/Controller/HomeControllerDoctor.dart';
import 'package:unity_test/View/Doctor/Home/HomePageDoctor.dart';
import 'package:unity_test/View/Map/Controller/MapController.dart';
import 'package:unity_test/View/Notifications/Controller/NotificationsPageController.dart';
import 'package:unity_test/View/Notifications/NotificationsPage.dart';
import 'package:unity_test/View/Room/Controller/RoomControlller.dart';
import 'package:unity_test/View/Map/map_screen.dart';
import 'package:unity_test/View/Room/RoomsScreen.dart';
import 'package:unity_test/View/Settings/settings_screen.dart';

class NavegationPageDoctorController with ChangeNotifier {
  int selectedIndex = 2; // تعيين "الرئيسية" كالشاشة الافتراضية عند بدء التطبيق

  final List<Widget> professorScreens = [
    const SettingsScreen(userType: 'teacher'), // الإعدادات
    ChangeNotifierProvider(
        create: (context) =>
            NotificationsPageController()..GetNotifications(context),
        builder: (context, child) => NotificationsPage()), // الإشعارات
    ChangeNotifierProvider(
      create: (context) => HomeControllerDoctor()..GetProfileDoctor(context),
      builder: (context, child) => HomePageDoctor(),
    ), // الرئيسية
    ChangeNotifierProvider(
        create: (context) => RoomControlller()..GetAllRoom(context),
        builder: (context, child) => RoomsScreen()), // الغرف
    ChangeNotifierProvider(
        create: (context) => MapController()..GetStudentsAndDoctors(context),
        builder: (context, child) => MapScreen()), // الخريطة
  ];

  final List<String> screenTitles = [
    'Settings',
    'Notifications',
    'Home',
    'Rooms',
    'Map',
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
