import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/View/Admin/Courses/Controller/CoursesController.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustomSearch.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseController>(
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
                            controller.searchCourse(query);
                          },
                        ),
                      ),
                      Gap(10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.DialogAddOrUpdateCourse(context),
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
                              ("Code"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Hall"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Day"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Time"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Time End"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Max Students"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Type"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Options"),
                            ),
                          )
                        ],
                        rows: controller.listCoursefilter
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.name ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.code ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.hall?.name ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.day?.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.time?.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.time_end?.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.maxStudents?.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Text(e.type?.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => controller
                                              .DialogAddOrUpdateCourse(context,
                                                  course: e),
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
                                              controller.DialogDeleteCourse(
                                                  context, e),
                                          label: Text("Delete"),
                                          icon: Icon(Icons.delete),
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
