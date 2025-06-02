// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';
import 'package:ypu_dashboard/Controller/ServicesProvider.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Admin/Announcements/AnnouncementPage.dart';
import 'package:ypu_dashboard/View/Admin/Announcements/Controller/AnnouncementController.dart';
import 'package:ypu_dashboard/View/Admin/Courses/Controller/CoursesController.dart';
import 'package:ypu_dashboard/View/Admin/Courses/CoursesPage.dart';
import 'package:ypu_dashboard/View/Admin/Doctors/Controller/DoctorController.dart';
import 'package:ypu_dashboard/View/Admin/Doctors/DoctorsPage.dart';
import 'package:ypu_dashboard/View/Admin/Employees/Controller/EmployeeController.dart';
import 'package:ypu_dashboard/View/Admin/Employees/EmployeesPage.dart';
import 'package:ypu_dashboard/View/Admin/Events/Controller/EventController.dart';
import 'package:ypu_dashboard/View/Admin/Events/EventsPage.dart';
import 'package:ypu_dashboard/View/Admin/Exam/Controller/ExamController.dart';
import 'package:ypu_dashboard/View/Admin/Exam/ExamPage.dart';
import 'package:ypu_dashboard/View/Admin/Halls/Controller/HallController.dart';
import 'package:ypu_dashboard/View/Admin/Halls/HallPage.dart';
import 'package:ypu_dashboard/View/Admin/Home/Controller/HomeController.dart';
import 'package:ypu_dashboard/View/Admin/Home/Home.dart';
import 'package:ypu_dashboard/View/Admin/Map/Controller/MapController.dart';
import 'package:ypu_dashboard/View/Admin/Map/MapPage.dart';
import 'package:ypu_dashboard/View/Admin/Students/Controller/StudentController.dart';
import 'package:ypu_dashboard/View/Admin/Students/StudentsPage.dart';
import 'package:ypu_dashboard/View/Widgets/SideBar/SideBar.dart';

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
            Gap(20),
            Center(
                child: Text(
              "YPU System",
              style: TextStyles.subheader.copyWith(color: AppColors.active),
            )),
            Gap(20),
            Divider(
              height: 10,
              thickness: 2,
            ),
            Gap(10),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => HomeController(),
                    builder: (context, child) => Home(),
                  )),
              title: Text(
                "Home",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/home.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => MapController(),
                    builder: (context, child) =>
                        SideBar(title: "Map", child: MapPage()),
                  )),
              title: Text(
                "Map",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: Icon(
                Icons.map,
                color: AppColors.primary,
                size: 25,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) =>
                        StudentController()..GetAllStudents(context),
                    builder: (context, child) =>
                        SideBar(title: "Student", child: StudentPage()),
                  )),
              title: Text(
                "Students",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/student.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) =>
                        DoctorController()..GetAllDoctors(context),
                    builder: (context, child) =>
                        SideBar(title: "Doctors", child: DoctorsPage()),
                  )),
              title: Text(
                "Doctors",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/commitee.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) =>
                        EmployeeController()..GetAllEmployees(context),
                    builder: (context, child) =>
                        SideBar(title: "Employee", child: EmployeePage()),
                  )),
              title: Text(
                "Employee",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/supervisor.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => HallController()..GetAllHalls(context),
                    builder: (context, child) =>
                        SideBar(title: "Rooms", child: HallPage()),
                  )),
              title: Text(
                "Rooms",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/hall.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => CourseController()
                      ..GetAllCourses(context)
                      ..GetAllHalls(context),
                    builder: (context, child) =>
                        SideBar(title: "Courses", child: CoursePage()),
                  )),
              title: Text(
                "Courses",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/course.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) =>
                        EventsController()..GetAllEvents(context),
                    builder: (context, child) =>
                        SideBar(title: "Events", child: EventsPage()),
                  )),
              title: Text(
                "Events",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/event.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) =>
                        AnnouncementController()..GetAllAnnouncements(context),
                    builder: (context, child) => SideBar(
                        title: "Announcements", child: AnnouncementPage()),
                  )),
              title: Text(
                "Announcements",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/announcement.svg',
                color: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () => CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => ExamController()
                      ..GetAllExams(context)
                      ..GetAllCourses(context),
                    builder: (context, child) =>
                        SideBar(title: "Exams", child: ExamPage()),
                  )),
              title: Text(
                "Exams",
                style: TextStyles.pramed.copyWith(color: AppColors.primary),
              ),
              leading: SvgPicture.asset(
                'assets/SVG/exam.svg',
                color: AppColors.primary,
              ),
            ),
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
