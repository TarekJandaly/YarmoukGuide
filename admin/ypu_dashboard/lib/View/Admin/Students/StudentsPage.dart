import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Admin/Schedule/Controller/ScheduleController.dart';
import 'package:ypu_dashboard/View/Admin/Schedule/SchedulePage.dart';
import 'package:ypu_dashboard/View/Admin/Students/Controller/StudentController.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustomSearch.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentController>(
        builder: (context, controller, child) => Scaffold(
              body: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextInputCustomSearch(
                          controller: controller.searchcontroller,
                          hint: "Search",
                          onSearch: (query) {
                            controller.searchStudent(query);
                          },
                        ),
                      ),
                      Gap(10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.DialogAddOrUpdateStudent(context),
                        icon: Icon(Icons.add),
                        label: Text("Add"),
                      )
                    ],
                  ),
                  Gap(10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              ("Name"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Phone"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Email"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Specialization"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Registered Year"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("University Number"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Options"),
                            ),
                          )
                        ],
                        rows: controller.listStudentfilter
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.user!.name),
                                  ),
                                  DataCell(
                                    Text(e.user!.phone),
                                  ),
                                  DataCell(
                                    Text(e.user!.email),
                                  ),
                                  DataCell(
                                    Text(e.specialization!.toString()),
                                  ),
                                  DataCell(
                                    Text(e.registeredYear!.toString()),
                                  ),
                                  DataCell(
                                    Text(e.universityNumber!.toString()),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => controller
                                              .DialogAddOrUpdateStudent(context,
                                                  student: e),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          AppColors.secondery)),
                                          label: Text("Edit"),
                                          icon: Icon(Icons.edit),
                                        ),
                                        Gap(10),
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          AppColors.red)),
                                          onPressed: () =>
                                              controller.DialogDeleteStudent(
                                                  context, e),
                                          label: Text("Delete"),
                                          icon: Icon(Icons.delete),
                                        ),
                                        Gap(10),
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          AppColors.secondery)),
                                          onPressed: () => CustomRoute.RouteTo(
                                              context,
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    ScheduleController()
                                                      ..GetAllCourses(context)
                                                      ..GetStudentCourses(
                                                          context, e.id!),
                                                builder: (context, child) =>
                                                    SchedulePage(
                                                  id: e.id,
                                                ),
                                              )),
                                          label: Text("Register Course"),
                                          icon: Icon(
                                              Icons.app_registration_rounded),
                                        )
                                      ],
                                    ),
                                  ),
                                ]))
                            .toList()),
                  ),
                ],
              ),
            ));
  }
}
