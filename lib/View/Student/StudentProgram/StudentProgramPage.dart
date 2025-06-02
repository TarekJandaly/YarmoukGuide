import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';
import 'package:unity_test/View/Student/StudentProgram/Controller/StudentProgramPageController.dart';

class StudentProgramPage extends StatelessWidget {
  const StudentProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProgramPageController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(title: Text("Courses")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.DialogScheduleCourses(context);
          },
          child: Icon(Icons.schedule),
        ),
        bottomNavigationBar: controller.selectedCourses.isNotEmpty
            ? Container(
                color: AppColors.basic,
                // height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          "Courses selected: ${controller.selectedCourses.length}"),
                      Gap(10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.DialogRegisterCourse(context),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors
                                  .primary, // إذا لم تكن محددة، تكون زرقاء
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: AppColors.basic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: ListView.builder(
          itemCount: controller.course.length,
          itemBuilder: (context, index) {
            final course = controller.course[index];
            final isSelected = controller.isCourseSelected(course);

            return Padding(
              padding: const EdgeInsets.all(8.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${course.name!} ${course.type! == 'practical' ? "(P)" : "(T)"}",
                        style: TextStyles.title,
                      ),
                      Text(course.code!, style: TextStyles.inputtitle),
                      Gap(10),
                      Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          Text(course.day!),
                          Text(course.time ?? 'Unknown'),
                          Icon(Icons.arrow_forward, size: 15),
                          Text(course.time_end ?? 'Unknown'),
                          Text("(${course.hall!.name!})"),
                        ],
                      ),
                      Gap(10),
                      Text("Dr. ${course.doctors![0].user!.name}"),
                      Gap(10),
                      Text(
                        course.canRegister!
                            ? "Available ${course.availableSlots}"
                            : "Not Available",
                        style: TextStyles.paraghraph.copyWith(
                          color: course.canRegister!
                              ? AppColors.active
                              : AppColors.red,
                        ),
                      ),
                      Gap(10),
                      GestureDetector(
                        onTap: () {
                          controller.toggleCourseSelection(course);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.red // إذا كانت محددة، تكون حمراء
                                : AppColors
                                    .primary, // إذا لم تكن محددة، تكون زرقاء
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              isSelected ? "Unselect" : "Select",
                              style: TextStyle(
                                color: AppColors.basic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
