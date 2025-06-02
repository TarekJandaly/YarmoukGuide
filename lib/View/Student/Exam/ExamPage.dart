import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unity_test/View/Student/Exam/Controller/ExamPageController.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamPageController>(
        builder: (context, controller, child) => Scaffold(
              appBar: AppBar(
                title: Text("Exam Schedule"),
              ),
              body: Skeletonizer(
                enabled: controller.isloadinggetexam,
                child: ListView(
                  children: [
                    DataTable(
                        columns: [
                          DataColumn(
                            label: Text("Course"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(
                            label: Text("Time"),
                          )
                        ],
                        rows: controller.exames
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.course!.name!),
                                  ),
                                  DataCell(
                                    Text(e.examDate!),
                                  ),
                                  DataCell(
                                    Text(e.examTime!),
                                  )
                                ]))
                            .toList())
                  ],
                ),
              ),
            ));
  }
}
