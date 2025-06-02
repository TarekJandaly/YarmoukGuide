import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Services/Routes.dart';
import 'package:ypu_dashboard/View/Admin/Doctors/Controller/DoctorController.dart';
import 'package:ypu_dashboard/View/Admin/LecturerDoctor/Controller/LecturerDoctorController.dart';
import 'package:ypu_dashboard/View/Admin/LecturerDoctor/LecturerDoctorPage.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustomSearch.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorController>(
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
                            controller.searchDoctor(query);
                          },
                        ),
                      ),
                      Gap(10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.DialogAddOrUpdateDoctor(context),
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
                              ("Options"),
                            ),
                          )
                        ],
                        rows: controller.listdoctorfilter
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
                                    Text(e.specialization),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => controller
                                              .DialogAddOrUpdateDoctor(context,
                                                  doctor: e),
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
                                              controller.DialogDeleteDoctor(
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
                                                    LecturerDoctorController()
                                                      ..GetAllCourses(context)
                                                      ..GetDoctorCourses(
                                                          context, e.id!),
                                                builder: (context, child) =>
                                                    LecturerDoctorPage(
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
