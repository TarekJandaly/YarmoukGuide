import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unity_test/View/Guest/Home/guest_screen.dart';

class NavegationPageGuestController with ChangeNotifier {
  int selectedIndex = 0;

  final List<Widget> guestScreens = [
    const GuestMapScreen(),
    const GuestHomeScreen(),
    const GuestSettingsScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
