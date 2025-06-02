// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ypu_dashboard/Services/NetworkClient.dart';

class HomeController with ChangeNotifier {
  static NetworkClient client = NetworkClient(http.Client());
  // bool isloading = false;

  // // 🔹 السنة الدراسية المختارة
  // String selectedYear =
  //     "${DateTime.now().subtract(Duration(days: 365)).year}-${DateTime.now().year}";

  // // 🔹 الفصول المتاحة
  // final List<String> semesters = ["Semester1", "Semester2", "Semester3"];

  // // 🔹 الفصل الدراسي المختار تلقائيًا بناءً على الشهر الحالي
  // String selectedSemester = _getCurrentSemester();
  // Logger logger = Logger();
  // static String _getCurrentSemester() {
  //   int currentMonth = DateTime.now().month;

  //   if ([9, 10, 11, 12, 1].contains(currentMonth)) {
  //     return "Semester1";
  //   } else if ([2, 3, 4, 5].contains(currentMonth)) {
  //     return "Semester2";
  //   } else {
  //     return "Semester3";
  //   }
  // }

  // ProjectModel? projectModelPrgress;
  // // 🔹 إرجاع المشاريع مفصولة حسب المشرفين
  // Map<String, List<Projects>> get projectsBySupervisor {
  //   return projectModelPrgress?.getProjectsBySupervisor() ?? {};
  // }

  // void initstate() {
  //   GetProjectsProgressForSupervisor();
  // }

  // void showYearPicker(BuildContext context, HomeController controller) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       child: SizedBox(
  //         height: 300,
  //         child: YearPicker(
  //           firstDate: DateTime(2000),
  //           lastDate: DateTime(2030),
  //           selectedDate: getStartYear(controller.selectedYear),
  //           currentDate: getStartYear(controller.selectedYear),
  //           onChanged: (DateTime newYear) {
  //             String selectedAcademicYear = formatAcademicYear(newYear.year);
  //             controller.updateYear(selectedAcademicYear);
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // DateTime getStartYear(String academicYear) {
  //   List<String> parts = academicYear.split('-');
  //   return DateTime(int.parse(parts[0]));
  // }

  // String formatAcademicYear(int year) {
  //   return "$year-${year + 1}";
  // }

  // Future<Either<Failure, bool>> GetProjectsProgressForSupervisor() async {
  //   isloading = true;
  //   projectModelPrgress = null;
  //   notifyListeners();

  //   try {
  //     final response = await client.request(
  //       requestType: RequestType.GET,
  //       path: AppApi.GetProjectsProgressForSupervisor(
  //           selectedYear, selectedSemester),
  //     );

  //     log(response.statusCode.toString());

  //     if (response.statusCode == 200) {
  //       var res = jsonDecode(utf8.decode(response.bodyBytes));
  //       log(res.toString());
  //       projectModelPrgress = ProjectModel.fromJson(res);
  //       logger.d(res);
  //       isloading = false;
  //       notifyListeners();
  //       return Right(true);
  //     } else if (response.statusCode == 404) {
  //       var res = jsonDecode(response.body);
  //       isloading = false;
  //       notifyListeners();
  //       return Left(ResultFailure(res['message']));
  //     } else {
  //       isloading = false;
  //       notifyListeners();
  //       return Left(GlobalFailure());
  //     }
  //   } catch (e) {
  //     isloading = false;
  //     notifyListeners();
  //     log(e.toString());
  //     log("Error in fetchProjects()");
  //     return Left(GlobalFailure());
  //   }
  // }

  // // 🔹 تحديث السنة الدراسية وإعادة تحميل البيانات
  // void updateYear(String newYear) {
  //   selectedYear = newYear;
  //   GetProjectsProgressForSupervisor();
  // }

  // // 🔹 تحديث الفصل الدراسي وإعادة تحميل البيانات
  // void updateSemester(String newSemester) {
  //   selectedSemester = newSemester;
  //   GetProjectsProgressForSupervisor();
  // }
}
