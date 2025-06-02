import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/View/Admin/Announcements/Controller/AnnouncementController.dart';
import 'package:ypu_dashboard/View/Widgets/TextInput/TextInputCustomSearch.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementController>(
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
                            controller.searchAnnouncement(query);
                          },
                        ),
                      ),
                      Gap(10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.DialogAddOrUpdateAnnouncement(context),
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
                              ("Title"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Description"),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              ("Options"),
                            ),
                          )
                        ],
                        rows: controller.listAnnouncementfilter
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.title!),
                                  ),
                                  DataCell(
                                    Text(e.description!),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => controller
                                              .DialogAddOrUpdateAnnouncement(
                                                  context,
                                                  Announcement: e),
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
                                          onPressed: () => controller
                                              .DialogDeleteAnnouncement(
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
