import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/View/Doctor/LecturerSchedule/Controller/LectureSchedulePageController.dart';

class LectureSchedulePage extends StatelessWidget {
  const LectureSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LectureSchedulePageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(
          title: Text("Lecture Schedule"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DataTable(
                  columns: [
                    DataColumn(
                      label: Text("Course"),
                    ),
                    DataColumn(
                      label: Text("Day"),
                    ),
                    DataColumn(
                      label: Text("Time Start"),
                    ),
                    DataColumn(
                      label: Text("Time End"),
                    ),
                    DataColumn(
                      label: Text("Doctor"),
                    ),
                    DataColumn(
                      label: Text("Type"),
                    ),
                    DataColumn(
                      label: Text("Room"),
                    )
                  ],
                  rows: controller.schedulecourses
                      .map((e) => DataRow(cells: [
                            DataCell(
                              Text(e.name!),
                            ),
                            DataCell(
                              Text(e.day!),
                            ),
                            DataCell(
                              Text(e.time!),
                            ),
                            DataCell(
                              Text(e.time_end ?? ""),
                            ),
                            DataCell(
                              Text(e.doctors?[0].user?.name ?? ""),
                            ),
                            DataCell(
                              Text(e.type!),
                            ),
                            DataCell(
                              Text(e.hall!.name!),
                            )
                          ]))
                      .toList())
            ],
          ),
        ),
      ),
    );
  }
}
