import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/View/Admin/Employees/Controller/EmployeeController.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustomSearch.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeController>(
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
                            controller.searchEmployee(query);
                          },
                        ),
                      ),
                      Gap(10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.DialogAddOrUpdateEmployee(context),
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
                              ("Department"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Options"),
                            ),
                          )
                        ],
                        rows: controller.listEmployeefilter
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
                                    Text(e.department!),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => controller
                                              .DialogAddOrUpdateEmployee(
                                                  context,
                                                  employee: e),
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
                                              controller.DialogDeleteEmployee(
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
