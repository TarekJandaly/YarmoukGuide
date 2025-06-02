class AppApi {
  static String url = "http://192.168.213.37:8000/api";
  static String urlImage = "http://192.168.213.37:8000/storage/";

  static String LOGIN = '/login';
  static String REGISTER = '/register';

  static String GetAllRoom = '/get-all-room';
  static String GetAvailableCourse = '/availableCourses';
  static String RegisterMultipleCourses = '/registerMultipleCourses';
  static String GetAllEvent = '/get-all-event';
  static String GetAllAnnouncements = '/get-all-announcements';
  static String GetAllExamsStudent = '/get-all-exams-student';
  static String UpdateProfile = '/update-profile';
  static String UpdateImageProfile = '/update-image-profile';
  static String GetStudentCourses = '/get-student-courses';
  static String GetDoctorCourses = '/get-doctor-courses';
  static String GetAllEmployee = '/get-all-employee';
  static String GetAllProblems = '/get-all-problems';
  static String SendProblem = '/send-problem';
  static String GetMyProblems = '/get-my-problems';
  static String FinishProblem(int id) => '/finish-problem/$id';

  static String GetProfileStudent = '/get-profile-student';
  static String GetProfileDoctor = '/get-profile-doctor';
  static String GetProfileEmployee = '/get-profile-employee';

  static String GetMessagesChat(int? idchat) => '/get-messages/$idchat';
  static String SendMessage = '/send-message';
  static String CreateChat = '/create-chat';
  static String GetChats = '/chats';

  static String GetStudentDoctors = '/get-student-doctors';
  static String GetMyStudent = '/get-my-student';
  static String GetNotifications = '/get-notifications';
  static String GetStudentsAndDoctors = '/getStudentsAndDoctors';
  static String UpdateUserLocation = '/updateUserLocation';
}
