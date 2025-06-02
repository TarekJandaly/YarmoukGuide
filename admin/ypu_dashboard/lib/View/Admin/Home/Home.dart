import 'package:flutter/material.dart';
import 'package:ypu_dashboard/View/Admin/Home/Controller/HomeController.dart';
import 'package:ypu_dashboard/View/Widgets/SideBar/SideBar.dart';
import 'package:provider/provider.dart';

import 'dart:ui'; // لاستيراد ImageFilter

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SideBar(
            title: "Home",
            child: Consumer<HomeController>(
                builder: (context, controller, child) => Center(
                        child: SingleChildScrollView(
                            child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // صورة الجامعة مع تأثير التغبش
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                  sigmaX: 10, sigmaY: 10), // قيمة التغبش
                              child: Image.asset(
                                'assets/images/ypu-2011_0517.jpg',
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 760,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))))));
  }
}




                              // Padding(
                              //   padding: const EdgeInsets.all(16),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       // 🔹 اختيار السنة الدراسية
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("Select Academic Year"),
                              //           TextButton(
                              //             onPressed: () => controller.showYearPicker(
                              //                 context, controller),
                              //             child: Text(
                              //               controller.selectedYear,
                              //               style: TextStyle(
                              //                   fontSize: 16, fontWeight: FontWeight.bold),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       // 🔹 اختيار الفصل الدراسي
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("Select Semester"),
                              //           DropdownButton<String>(
                              //             value: controller.selectedSemester,
                              //             items: controller.semesters
                              //                 .map((sem) => DropdownMenuItem(
                              //                       value: sem,
                              //                       child: Text(sem),
                              //                     ))
                              //                 .toList(),
                              //             onChanged: (value) {
                              //               if (value != null) {
                              //                 controller.updateSemester(value);
                              //               }
                              //             },
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // controller.isloading
                              //     // ? Center(
                              //     //     child: LoadingAnimationWidget.fourRotatingDots(
                              //     //         color: AppColors.active, size: 30))
                              //     : controller.projectModelPrgress == null
                              //         ? Text("No Project Available")
                              // : Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(16),
                              //       child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Row(
                              //                 children: [
                              //                   Text("Project Count: "),
                              //                   Text(
                              //                     controller.projectModelPrgress!
                              //                         .totalProjects!
                              //                         .toString(),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Gap(20),
                              //               Row(
                              //                 children: [
                              //                   Text("Average Completion Rate: "),
                              //                   Text(
                              //                     controller.projectModelPrgress!
                              //                         .averageCompletionRate!
                              //                         .toString(),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           Text(
                              //             "Supervisor",
                              //             style: TextStyles.title,
                              //           ),
                              //           controller.projectModelPrgress!.supervisors
                              //                   .isNotEmpty
                              //               ? GridView.builder(
                              //                   gridDelegate:
                              //                       SliverGridDelegateWithFixedCrossAxisCount(
                              //                           crossAxisCount: 2,
                              //                           crossAxisSpacing: 10,
                              //                           childAspectRatio: 5,
                              //                           mainAxisSpacing: 10),
                              //                   shrinkWrap: true,
                              //                   itemCount: controller
                              //                       .projectModelPrgress!
                              //                       .supervisors
                              //                       .length,
                              //                   itemBuilder: (context, index) =>
                              //                       Padding(
                              //                     padding:
                              //                         const EdgeInsets.all(8.0),
                              //                     child: Container(
                              //                       decoration: BoxDecoration(
                              //                           color: AppColors.basic,
                              //                           borderRadius:
                              //                               BorderRadius.circular(
                              //                                   20),
                              //                           boxShadow: [
                              //                             BoxShadow(
                              //                                 blurRadius: 7,
                              //                                 offset: Offset(0, 2),
                              //                                 color: Color(
                              //                                         0xff000000)
                              //                                     .withOpacity(.5))
                              //                           ]),
                              //                       child: Padding(
                              //                         padding:
                              //                             const EdgeInsets.all(8.0),
                              //                         child: Column(
                              //                           crossAxisAlignment:
                              //                               CrossAxisAlignment
                              //                                   .start,
                              //                           mainAxisAlignment:
                              //                               MainAxisAlignment.start,
                              //                           children: [
                              //                             Row(
                              //                               children: [
                              //                                 Icon(
                              //                                   Icons.circle,
                              //                                   size: 12.sp,
                              //                                 ),
                              //                                 Gap(5),
                              //                                 Text(
                              //                                   "Supervisor: ",
                              //                                 ),
                              //                                 Text(controller
                              //                                     .projectModelPrgress!
                              //                                     .supervisors[
                              //                                         index]
                              //                                     .supervisor),
                              //                               ],
                              //                             ),
                              //                             Row(
                              //                               children: [
                              //                                 Icon(
                              //                                   Icons.circle,
                              //                                   size: 12.sp,
                              //                                 ),
                              //                                 Gap(5),
                              //                                 Text(
                              //                                   "Total project: ",
                              //                                 ),
                              //                                 Text(controller
                              //                                     .projectModelPrgress!
                              //                                     .supervisors[
                              //                                         index]
                              //                                     .totalProjects
                              //                                     .toString()),
                              //                               ],
                              //                             ),
                              //                             Row(
                              //                               children: [
                              //                                 Icon(
                              //                                   Icons.circle,
                              //                                   size: 12.sp,
                              //                                 ),
                              //                                 Gap(5),
                              //                                 Text(
                              //                                   "Average Completion Rate: ",
                              //                                 ),
                              //                                 Text(controller
                              //                                     .projectModelPrgress!
                              //                                     .supervisors[
                              //                                         index]
                              //                                     .averageCompletionRate
                              //                                     .toString()),
                              //                               ],
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 )
                              //               : Text("data"),
                              //           Divider(),
                              //           Text(
                              //             "Projects",
                              //             style: TextStyles.title,
                              //           ),
                              //           // controller.projectModelPrgress!.projects
                              //           //         .isNotEmpty
                              //           // ? GridView.builder(
                              //           //     gridDelegate:
                              //           //         SliverGridDelegateWithFixedCrossAxisCount(
                              //           //             crossAxisCount: 2,
                              //           //             crossAxisSpacing: 10,
                              //           //             childAspectRatio: 5,
                              //           //             mainAxisSpacing: 10),
                              //           //     shrinkWrap: true,
                              //           //     itemCount: controller
                              //           //         .projectModelPrgress!
                              //           //         .projects
                              //           //         .length,
                              //           //     itemBuilder: (context, index) =>
                              //           //         Padding(
                              //           //       padding:
                              //           //           const EdgeInsets.all(8.0),
                              //           //       child: GestureDetector(
                              //           //         onTap: () =>
                              //           //             CustomRoute.RouteTo(
                              //           //                 context,
                              //           //                 ChangeNotifierProvider(
                              //           //                   create: (context) =>
                              //           //                       ProjectDetailsController()
                              //           //                         ..GetProjectProgress(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId)
                              //           //                         ..GetProjectWithStudent(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId)
                              //           //                         ..initstate(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId)
                              //           //                         ..GetTasksProjectWithStudent(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId)
                              //           //                         ..ProjectActivityLog(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectName)
                              //           //                         ..GetNotifications(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId)
                              //           //                         ..GetProjectDocuments(controller
                              //           //                             .projectModelPrgress!
                              //           //                             .projects[
                              //           //                                 index]
                              //           //                             .projectId),
                              //           //                   builder: (context, child) => SideBar(
                              //           //                       title: "${controller.projectModelPrgress!.projects[index].projectName}",
                              //           //                       child: ProjectDetails(
                              //           //                           // project: controller
                              //           //                           //           .projectModelPrgress!
                              //           //                           //           .projects[index],
                              //           //                           )),
                              //           //                 )),
                              //           //         child: Container(
                              //           //           decoration: BoxDecoration(
                              //           //               color: AppColors.basic,
                              //           //               borderRadius:
                              //           //                   BorderRadius.circular(
                              //           //                       20),
                              //           //               boxShadow: [
                              //           //                 BoxShadow(
                              //           //                     blurRadius: 7,
                              //           //                     offset:
                              //           //                         Offset(0, 2),
                              //           //                     color: Color(
                              //           //                             0xff000000)
                              //           //                         .withOpacity(
                              //           //                             .5))
                              //           //               ]),
                              //           //           child: Padding(
                              //           //             padding:
                              //           //                 const EdgeInsets.all(
                              //           //                     8.0),
                              //           //             child: Column(
                              //           //               crossAxisAlignment:
                              //           //                   CrossAxisAlignment
                              //           //                       .start,
                              //           //               mainAxisAlignment:
                              //           //                   MainAxisAlignment
                              //           //                       .start,
                              //           //               children: [
                              //           //                 Row(
                              //           //                   children: [
                              //           //                     Icon(
                              //           //                       Icons.circle,
                              //           //                       size: 12.sp,
                              //           //                     ),
                              //           //                     Gap(5),
                              //           //                     Text(
                              //           //                       "Project name: ",
                              //           //                     ),
                              //           //                     Text(controller
                              //           //                         .projectModelPrgress!
                              //           //                         .projects[index]
                              //           //                         .projectName),
                              //           //                   ],
                              //           //                 ),
                              //           //                 Row(
                              //           //                   children: [
                              //           //                     Icon(
                              //           //                       Icons.circle,
                              //           //                       size: 12.sp,
                              //           //                     ),
                              //           //                     Gap(5),
                              //           //                     Text(
                              //           //                       "Supervisor: ",
                              //           //                     ),
                              //           //                     Text(controller
                              //           //                         .projectModelPrgress!
                              //           //                         .projects[index]
                              //           //                         .supervisor
                              //           //                         .toString()),
                              //           //                   ],
                              //           //                 ),
                              //           //                 Row(
                              //           //                   children: [
                              //           //                     Icon(
                              //           //                       Icons.circle,
                              //           //                       size: 12.sp,
                              //           //                     ),
                              //           //                     Gap(5),
                              //           //                     Text(
                              //           //                       "Project Completion Rate: ",
                              //           //                     ),
                              //           //                     Text(controller
                              //           //                         .projectModelPrgress!
                              //           //                         .projects[index]
                              //           //                         .projectCompletionRate
                              //           //                         .toString()),
                              //           //                   ],
                              //           //                 ),
                              //           //               ],
                              //           //             ),
                              //           //           ),
                              //           //         ),
                              //           //       ),
                              //           //     ),
                              //           //   )
                              //           // : Text("data")
                              //         ],
                              //       ),
                              //     ),
                              //   ),
