import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/View/Announcement/AnnouncementPage.dart';
import 'package:unity_test/View/Announcement/Controller/AnnouncementPageController.dart';
import 'package:unity_test/View/Employee/Home/Controller/HomeControllerEmployee.dart';
import 'package:unity_test/View/Employee/Problem/Controller/ProblemPageEmployeeController.dart';
import 'package:unity_test/View/Employee/Problem/ProblemPageEmployee.dart';

class HomePageEmployee extends StatelessWidget {
  const HomePageEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeControllerEmployee>(
      builder: (context, controller, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // القسم الأول: ترحيب بالمستخدم
            Skeletonizer(
              enabled: controller.isloadinggetprofile,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Container(
                              color: AppColors.secondery,
                              width: 90,
                              height: 90,
                              child: controller.user.profilePicture != null
                                  ? Image.network(
                                      "${AppApi.urlImage}${controller.user.profilePicture!}",
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.basic,
                                      ),
                                    )),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hello, ${controller.user.name}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('${controller.user.employee?.department}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // القسم الثاني: شريط السلايدات
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // _buildSliderTile(
                  //   context,
                  //   Icons.work,
                  //   'My Tasks',
                  //   'View Daily Tasks',
                  //   const EmployeeTasksScreen(),
                  // ),
                  // _buildSliderTile(
                  //   context,
                  //   Icons.schedule,
                  //   'Meeting Schedule',
                  //   'View Meeting Schedule',
                  //   const MeetingScheduleScreen(),
                  // ),
                  _buildSliderTile(
                    context,
                    Icons.announcement,
                    'Advertisements',
                    'View Employee Announcements',
                    ChangeNotifierProvider(
                      create: (context) => AnnouncementPageController()
                        ..GetAllAnnouncements(context),
                      builder: (context, child) => AnnouncementPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.report,
                    'Reports',
                    'View Work Reports',
                    ChangeNotifierProvider(
                      create: (context) => ProblemPageEmployeeController()
                        ..GetMyProblems(context),
                      builder: (context, child) => ProblemPageEmployee(),
                    ),
                  ),
                ],
              ),
            ),

            // القسم الثالث: الخريطة المصغرة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Minimap appears here (you are here)',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Widget targetScreen,
  ) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 50, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeTasksScreen extends StatelessWidget {
  const EmployeeTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
      ),
      body: const Center(
        child: Text('Here the employee daily tasks are displayed.'),
      ),
    );
  }
}

class MeetingScheduleScreen extends StatelessWidget {
  const MeetingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting schedule'),
      ),
      body: const Center(
        child: Text('Meeting times are displayed here.'),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: const Center(
        child: Text('Here are the work reports displayed.'),
      ),
    );
  }
}

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertisements'),
      ),
      body: const Center(
        child: Text('Here are displayed advertisements for employees.'),
      ),
    );
  }
}

// void _showFullImage(BuildContext context, String imagePath) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.transparent,
//         child: InteractiveViewer(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.asset(imagePath, fit: BoxFit.cover),
//           ),
//         ),
//       );
//     },
//   );
// }
