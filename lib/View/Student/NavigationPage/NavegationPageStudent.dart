import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/View/Student/NavigationPage/Controller/NavegationPageStudentController.dart';

class NavegationPageStudent extends StatelessWidget {
  const NavegationPageStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavegationPageStudentController>(
        builder: (context, controller, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  controller.screenTitles[controller.selectedIndex],
                  style: const TextStyle(
                    color: Colors.white, // تحديد اللون الأبيض للنص
                    fontWeight: FontWeight.bold, // جعل الخط عريض (Bold)
                  ),
                ),
                centerTitle: true, // وضع النص في المنتصف
                backgroundColor: Theme.of(context).primaryColor, // لون الخلفية
                iconTheme: const IconThemeData(
                    color: Colors
                        .white), // تغيير لون أيقونات الشريط العلوي إلى الأبيض
              ),
              body: controller.studentScreens[controller.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.selectedIndex,
                onTap: controller.onItemTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.room),
                    label: 'Rooms',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Map',
                  ),
                ],
                selectedIconTheme: const IconThemeData(size: 30),
              ),
            ));
  }
}
