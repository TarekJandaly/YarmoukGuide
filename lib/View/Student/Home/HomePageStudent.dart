import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/url.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Announcement/AnnouncementPage.dart';
import 'package:unity_test/View/Announcement/Controller/AnnouncementPageController.dart';
import 'package:unity_test/View/Event/Controller/EventPageController.dart';
import 'package:unity_test/View/Event/EventPage.dart';
import 'package:unity_test/View/Student/Exam/Controller/ExamPageController.dart';
import 'package:unity_test/View/Student/Exam/ExamPage.dart';
import 'package:unity_test/View/Student/Home/Controller/HomeControllerStudent.dart';
import 'package:unity_test/View/Student/MyDoctor/Controller/MyDoctorPageController.dart';
import 'package:unity_test/View/Student/MyDoctor/MyDoctorPage.dart';
import 'package:unity_test/View/Student/StudentProgram/Controller/StudentProgramPageController.dart';
import 'package:unity_test/View/Student/StudentProgram/StudentProgramPage.dart';

class HomePageStudent extends StatelessWidget {
  const HomePageStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeControllerStudent>(
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
                  elevation: 4, // إضافة ظل خفيف للبطاقة
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // جعل الحواف دائرية
                  ),
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${controller.user.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Student ID: ${controller.user.student?.universityNumber}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${controller.user.student?.specialization} - ${controller.user.student?.registeredYear}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
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
                    'Student Program',
                    'View your daily program',
                    ChangeNotifierProvider(
                      create: (context) => StudentProgramPageController()
                        ..GetAvailableCourse(context)
                        ..GetStudentCourses(context),
                      builder: (context, child) => StudentProgramPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.book,
                    'Exam Schedule',
                    'View Exam Dates',
                    ChangeNotifierProvider(
                      create: (context) =>
                          ExamPageController()..GetAllExamsStudent(context),
                      builder: (context, child) => ExamPage(),
                    ),
                  ),
                  _buildSliderTile(
                    context,
                    Icons.group,
                    'Doctors',
                    'Enter and view all doctor courses',
                    ChangeNotifierProvider(
                      create: (context) =>
                          MyDoctorPageController()..GetStudentDoctors(context),
                      builder: (context, child) => MyDoctorPage(),
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
            CustomRoute.RouteTo(context, targetScreen);
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
