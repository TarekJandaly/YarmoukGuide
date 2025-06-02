import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/View/Guest/NavigationPage/Controller/NavegationPageGuestController.dart';

class NavegationPageGuest extends StatelessWidget {
  const NavegationPageGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavegationPageGuestController>(
        builder: (context, controller, child) => Scaffold(
              body: controller.guestScreens[controller.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.selectedIndex,
                onTap: (value) => controller.onItemTapped(value),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ));
  }
}
