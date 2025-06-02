import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/View/Announcement/AnnouncementPage.dart';
import 'package:unity_test/View/Announcement/Controller/AnnouncementPageController.dart';
import 'package:unity_test/View/Doctor/Home/Controller/HomeControllerDoctor.dart';
import 'package:unity_test/View/Doctor/LecturerSchedule/Controller/LectureSchedulePageController.dart';
import 'package:unity_test/View/Doctor/LecturerSchedule/LectureSchedulePage.dart';
import 'package:unity_test/View/Doctor/MyStudent/Controller/MyStudentPageController.dart';
import 'package:unity_test/View/Doctor/MyStudent/MyStudentPage.dart';
import 'package:unity_test/View/Doctor/Problem/Controller/ProblemPageController.dart';
import 'package:unity_test/View/Doctor/Problem/ProblemPage.dart';
import 'package:unity_test/View/Event/Controller/EventPageController.dart';
import 'package:unity_test/View/Event/EventPage.dart';

class HomePageDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeControllerDoctor>(
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
                                  : Icon(
                                      Icons.person,
                                      size: 100,
                                      color: AppColors.basic,
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
                              // Text('ID: $userId',
                              //     style: TextStyle(
                              //         fontSize: 14,
                              //         color: Theme.of(context).primaryColor)),
                              Text('${controller.user.doctor?.specialization}',
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
                  _buildSliderTile(
                    context,
                    Icons.schedule,
                    'Lecture Schedule',
                    'View Lecture Schedule',
                    ChangeNotifierProvider(
                      create: (context) => LectureSchedulePageController()
                        ..GetDoctorCourses(context),
                      builder: (context, child) => LectureSchedulePage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.bug_report_sharp,
                    'Problems',
                    'Send problem to employee',
                    ChangeNotifierProvider(
                      create: (context) => ProblemPageController()
                        ..GetAllProblems(context)
                        ..GetAllEmployee(context),
                      builder: (context, child) => ProblemPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.group,
                    'My student',
                    'Enter and view all student in lecture',
                    ChangeNotifierProvider(
                      create: (context) =>
                          MyStudentPageController()..GetMyStudent(context),
                      builder: (context, child) => MyStudentPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.announcement,
                    'Ads',
                    'Show new ads',
                    ChangeNotifierProvider(
                      create: (context) => AnnouncementPageController()
                        ..GetAllAnnouncements(context),
                      builder: (context, child) => AnnouncementPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.event,
                    'Events',
                    'View University Events',
                    ChangeNotifierProvider(
                      create: (context) =>
                          EventPageController()..GetAllEvent(context),
                      builder: (context, child) => EventPage(),
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

class LectureScheduleScreen extends StatelessWidget {
  const LectureScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture schedule'),
      ),
      body: const Center(
        child: Text('Here is the professor lecture schedule.'),
      ),
    );
  }
}

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duties'),
      ),
      body: const Center(
        child: Text('Here duties and tasks are managed.'),
      ),
    );
  }
}

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Degrees'),
      ),
      body: const Center(
        child: Text('Here students grades are entered and displayed.'),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: const Center(
        child: Text('This is where university events are managed.'),
      ),
    );
  }
}
