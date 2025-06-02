<?php

namespace App\Http\Controllers;

use App\Models\Course;
use App\Models\Exam;
use App\Models\Notification;
use App\Models\Student;
use App\Services\FcmNotificationService;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ExamController
{
    use YPUSystemTrait;

    public function getExamSchedule()
    {
        $user = Auth::user();

        $student = Student::where("user_id", $user->id)->first();

        if (!$student) {
            return $this->ErrorResponse('Student record not found', 404);
        }

        $courseIds = $student->courses()->pluck('course_id');

        $exams = Exam::whereIn('course_id', $courseIds)->with('course')->get();

        if ($exams->isEmpty()) {
            return $this->ErrorResponse('No exams found for your courses', 404);
        }

        return $this->SuccessResponse($exams, 'Exams retrieved successfully', 200);
    }


      public function getAllExams()
      {
          $exams = Exam::with('course')->get();

          if ($exams->isEmpty()) {
              return $this->ErrorResponse('No exams found', 404);
          }

          return $this->SuccessResponse($exams, 'Exams retrieved successfully', 200);
      }

      public function AddExam(Request $request,FcmNotificationService $fcmService)
      {
          $validator = Validator::make($request->all(), [
              'course_id' => 'required|exists:courses,id',
              'exam_date' => 'required|date',
              'exam_time' => 'required',
          ]);

          if ($validator->fails()) {
              return $this->ErrorResponse($validator->errors()->first(), 400);
          }

          $exam = Exam::create([
              'course_id' => $request->course_id,
              'exam_date' => $request->exam_date,
              'exam_time' => $request->exam_time,
          ]);

        $course = Course::with(['students.user', 'doctors.user'])->find($request->course_id);

        $message = "📄 New exam scheduled for course: {$course->name}";

        foreach ($course->students as $student) {
            $user = $student->user;
            if ($user) {
                Notification::create([
                    'user_id' => $user->id,
                    'message' => $message,
                ]);

                $fcmService->sendFcmNotification(
                    $user->id,
                    '📄 New Exam',
                    $message
                );
            }
        }

        foreach ($course->doctors as $doctor) {
            $user = $doctor->user;
            if ($user) {
                Notification::create([
                    'user_id' => $user->id,
                    'message' => $message,
                ]);

                $fcmService->sendFcmNotification(
                    $user->id,
                    '📄 New Exam',
                    $message
                );
            }
        }

          return $this->SuccessResponse($exam, 'Exam created successfully', 201);
      }

      public function UpdateExam(Request $request, $id)
      {
          $exam = Exam::find($id);

          if (!$exam) {
              return $this->ErrorResponse('Exam not found', 404);
          }

          $validator = Validator::make($request->all(), [
              'course_id' => 'nullable|exists:courses,id',
              'exam_date' => 'nullable|date',
              'exam_time' => 'nullable',
          ]);

          if ($validator->fails()) {
              return $this->ErrorResponse($validator->errors()->first(), 400);
          }

          $exam->update($request->only(['course_id', 'exam_date', 'exam_time']));

          return $this->SuccessResponse($exam, 'Exam updated successfully', 200);
      }

      public function DeleteExam($id)
      {
          $exam = Exam::find($id);

          if (!$exam) {
              return $this->ErrorResponse('Exam not found', 404);
          }

          $exam->delete();

          return $this->SuccessResponse(null, 'Exam deleted successfully', 200);
      }
}
