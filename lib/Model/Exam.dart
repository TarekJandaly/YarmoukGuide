import 'package:unity_test/Model/Course.dart';

class Exam {
  int? id;
  int? courseId;
  String? examDate;
  String? examTime;
  var createdAt;
  var updatedAt;
  Course? course;

  Exam(
      {this.id,
      this.courseId,
      this.examDate,
      this.examTime,
      this.createdAt,
      this.updatedAt,
      this.course});

  Exam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    examDate = json['exam_date'];
    examTime = json['exam_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
  }
}
