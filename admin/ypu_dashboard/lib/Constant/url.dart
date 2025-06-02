class AppApi {
  static String url = "http://127.0.0.1:8000/api";
  static String urlImage = "http://127.0.0.1:8000/storage/";

  static String LOGIN = '/login';

  static String GetAllDoctors = '/doctors';
  static String AddDoctors = '/doctors';
  static String DeleteDoctors(int id) => '/doctors/$id';
  static String UpdateDoctors(int id) => '/doctors/$id';
  //////////////////////////////////////////////////////
  static String GetAllEmployees = '/employees';
  static String AddEmployees = '/employees';
  static String DeleteEmployees(int id) => '/employees/$id';
  static String UpdateEmployees(int id) => '/employees/$id';
  //////////////////////////////////////////////////////
  static String GetAllStudents = '/students';
  static String AddStudents = '/students';
  static String DeleteStudents(int id) => '/students/$id';
  static String UpdateStudents(int id) => '/students/$id';
  //////////////////////////////////////////////////////
  static String GetAllCourses = '/courses';
  static String AddCourses = '/courses';
  static String DeleteCourses(int id) => '/courses/$id';
  static String UpdateCourses(int id) => '/courses/$id';
  //////////////////////////////////////////////////////
  static String GetAllHalls = '/halls';
  static String AddHalls = '/halls';
  static String DeleteHalls(int id) => '/halls/$id';
  static String UpdateHalls(int id) => '/halls/$id';
  //////////////////////////////////////////////////////
  static String GetAllEvents = '/events';
  static String AddEvents = '/events';
  static String DeleteEvents(int id) => '/events/$id';
  static String UpdateEvents(int id) => '/events/$id';
  //////////////////////////////////////////////////////
  static String GetAllAnnouncements = '/announcements';
  static String AddAnnouncements = '/announcements';
  static String DeleteAnnouncements(int id) => '/announcements/$id';
  static String UpdateAnnouncements(int id) => '/announcements/$id';
  //////////////////////////////////////////////////////
  static String GetAllExams = '/exams';
  static String AddExams = '/exams';
  static String DeleteExams(int id) => '/exams/$id';
  static String UpdateExams(int id) => '/exams/$id';
  //////////////////////////////////////////////////////
  static String GetStudentCourses(int id) => '/getScheduleStudentCourses/$id';
  static String RegisterMultipleCourses(int id) =>
      '/registerMultipleCourses/$id';
  //////////////////////////////////////////////////////
  static String GetDoctorCourses(int id) => '/getScheduleDoctorLectures/$id';
  static String AssignCoursesToDoctor(int id) => '/assignCoursesToDoctor/$id';
  //////////////////////////////////////////////////////
  static String UploadAndConvertMap = '/uploadAndConvertMap';
  //////////////////////////////////////////
  static String GetAllImages = '/images';
  static String AddImages = '/images';
  static String DeleteImages(int id) => '/images/$id';
}
