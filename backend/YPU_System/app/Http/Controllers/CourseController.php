<?php

namespace App\Http\Controllers;

use App\Models\Course;
use App\Models\Doctor;
use App\Models\Student;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CourseController
{

    use YPUSystemTrait;
     public function availableCourses()
     {
         $courses = Course::with(['doctors.user','hall'])->get()->map(function ($course) {
            $studentsCount = $course->students()->count();

            $course->available_slots = $course->max_students - $studentsCount;

            $course->can_register = $course->available_slots > 0;

            return $course;
        });

         return $this->SuccessResponse(
             $courses,'All Courses'
         , 200);
     }


    public function registerMultipleCourses(Request $request)
    {
        $user = Auth::user();
        $student=Student::where("user_id",$user->id)->first();
        $request->validate([
            'course_ids' => 'required|array',
            'course_ids.*' => 'exists:courses,id',
        ]);
        $selectedCourses = Course::whereIn('id', $request->course_ids)->get();

        $alreadyRegistered = $student->courses()->whereIn('course_id', $request->course_ids)->exists();
        if ($alreadyRegistered) {
            return $this->ErrorResponse("You have already registered, you cannot re-register!", 400);
        }

        $failedCourses = [];
        foreach ($selectedCourses as $course) {
            $maxStudents = $course->max_students;
            $currentStudents = $course->students()->count();

            if ($currentStudents >= $maxStudents) {
                $failedCourses[] = [
                    'course_id' => $course->id,
                ];
            }
        }

        if (!empty($failedCourses)) {
            return $this->ErrorResponse("Registration failed, there are full materials", 400);
        }

        DB::beginTransaction();
        try {
            foreach ($selectedCourses as $course) {
                $student->courses()->attach($course->id);
            }

            DB::commit();
            return $this->SuccessResponse(
                '','Successfully registered for all subjects', 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return $this->ErrorResponse('An error occurred during registration, no item was registered', 500);
        }
    }


    public function registerMultipleCoursesFormAdmin(Request $request,$id)
    {
        $student=Student::find($id);
        $request->validate([
            'course_ids' => 'required|array',
            'course_ids.*' => 'exists:courses,id',
        ]);
        $selectedCourses = Course::whereIn('id', $request->course_ids)->get();

        $alreadyRegistered = $student->courses()->whereIn('course_id', $request->course_ids)->exists();
        if ($alreadyRegistered) {
            return $this->ErrorResponse("You have already registered, you cannot re-register!", 400);
        }

        $failedCourses = [];
        foreach ($selectedCourses as $course) {
            $maxStudents = $course->max_students;
            $currentStudents = $course->students()->count();

            if ($currentStudents >= $maxStudents) {
                $failedCourses[] = [
                    'course_id' => $course->id,
                ];
            }
        }

        if (!empty($failedCourses)) {
            return $this->ErrorResponse("Registration failed, there are full materials", 400);
        }

        DB::beginTransaction();
        try {
            foreach ($selectedCourses as $course) {
                $student->courses()->attach($course->id);
            }

            DB::commit();
            return $this->SuccessResponse(
                '','Successfully registered for all subjects', 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return $this->ErrorResponse('An error occurred during registration, no item was registered', 500);
        }
    }

    public function getStudentCourses()
    {
        $user = Auth::user();

        $student = Student::where('user_id', $user->id)->first();

        if (!$student) {
            return $this->ErrorResponse('Student record not found', 404);
        }

        $courses = $student->courses()->with(['hall','doctors.user'])->get();

        if ($courses->isEmpty()) {
            return $this->ErrorResponse('No courses found for this student', 404);
        }

        return $this->SuccessResponse($courses, 'Courses retrieved successfully', 200);
    }

    public function getScheduleStudentCourses(Request $request,$id)
    {

        $student = Student::find($id);

        if (!$student) {
            return $this->ErrorResponse('Student record not found', 404);
        }

        $courses = $student->courses()->with(['hall','doctors.user'])->get();

        if ($courses->isEmpty()) {
            return $this->ErrorResponse('No courses found for this student', 404);
        }

        return $this->SuccessResponse($courses, 'Courses retrieved successfully', 200);
    }



    public function getDoctorLectures()
    {
        $user = Auth::user();

        $doctor = Doctor::where('user_id', $user->id)->first();

        if (!$doctor) {
            return $this->ErrorResponse('Doctor record not found', 404);
        }

        $courses = $doctor->courses()->with(['hall','doctors.user'])->get();

        if ($courses->isEmpty()) {
            return $this->ErrorResponse('No courses found for this doctor', 404);
        }

        return $this->SuccessResponse($courses, 'Courses retrieved successfully', 200);
    }

    public function getScheduleDoctorLectures($id)
    {
        $user = Auth::user();

        $doctor = Doctor::find($id);

        if (!$doctor) {
            return $this->ErrorResponse('Doctor record not found', 404);
        }

        $courses = $doctor->courses()->with(['hall','doctors.user'])->get();

        if ($courses->isEmpty()) {
            return $this->ErrorResponse('No courses found for this doctor', 404);
        }

        return $this->SuccessResponse($courses, 'Courses retrieved successfully', 200);
    }

    public function assignCoursesToDoctor(Request $request,$id)
    {
        try {
            $validated = $request->validate([
                'course_ids' => 'required|array|min:1',
                'course_ids.*' => 'exists:courses,id',
            ]);

            $doctor = Doctor::find($id);

            $doctor->courses()->syncWithoutDetaching($validated['course_ids']);

            return $this->SuccessResponse(null, 'Courses assigned to doctor successfully', 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->ErrorResponse($e->errors(), 422);
        } catch (\Exception $e) {
            return $this->ErrorResponse($e->getMessage(), 500);
        }
    }


     public function getAllCourses()
     {
         $courses = Course::with('hall')->get();

         if ($courses->isEmpty()) {
             return $this->ErrorResponse('No courses found', 404);
         }

         return $this->SuccessResponse($courses, 'Courses retrieved successfully', 200);
     }

     public function AddCourse(Request $request)
     {
         $validator = Validator::make($request->all(), [
             'name' => 'required|string',
             'code' => 'required|string|unique:courses,code',
             'hall_id' => 'required|integer',
             'day' => 'required|string',
             'time' => 'required|string',
             'time_end' => 'required|string',
             'max_students' => 'required|integer',
             'type' => 'required|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $course = Course::create([
             'name' => $request->name,
             'code' => $request->code,
             'hall_id' => $request->hall_id,
             'day' => $request->day,
             'time' => $request->time,
             'time_end' => $request->time_end,
             'max_students' => $request->max_students,
             'type' => $request->type,
         ]);

         return $this->SuccessResponse($course, 'Course added successfully', 201);
     }

     public function UpdateCourse(Request $request, $id)
     {
         $course = Course::find($id);

         if (!$course) {
             return $this->ErrorResponse('Course not found', 404);
         }

         $validator = Validator::make($request->all(), [
             'name' => 'nullable|string',
             'code' => 'nullable|string|unique:courses,code,' . $id,
             'hall_id' => 'nullable|integer',
             'day' => 'nullable|string',
             'time' => 'nullable|string',
             'time_end' => 'nullable|string',
             'max_students' => 'nullable|integer',
             'type' => 'nullable|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $course->update($request->only([
             'name',
             'code',
             'hall_id',
             'day',
             'time',
             'time_end',
             'max_students',
             'type',
         ]));

         return $this->SuccessResponse($course, 'Course updated successfully', 200);
     }

     public function DeleteCourse($id)
     {
         $course = Course::find($id);

         if (!$course) {
             return $this->ErrorResponse('Course not found', 404);
         }

         $course->delete();

         return $this->SuccessResponse(null, 'Course deleted successfully', 200);
     }
}
