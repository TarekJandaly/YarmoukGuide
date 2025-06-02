import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/View/Employee/Problem/Controller/ProblemPageEmployeeController.dart';

class ProblemPageEmployee extends StatelessWidget {
  const ProblemPageEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProblemPageEmployeeController>(
        builder: (context, controller, child) => Scaffold(
              appBar: AppBar(
                title: Text("Problems"),
              ),
              body: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.problems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.basic,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: AppColors.black.withAlpha(50),
                          offset: Offset(0, 3.5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.problems[index].description!,
                                  style: TextStyles.title,
                                ),
                                Text(
                                  controller.problems[index].status == 1
                                      ? "Fixed"
                                      : "Pending",
                                  style: TextStyles.inputtitle,
                                )
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () => controller.FinishProblem(
                                  context, controller.problems[index].id!),
                              child: Text("Finish"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
