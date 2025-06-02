<?php

namespace App\Http\Controllers;

use App\Models\Course;
use App\Models\Doctor;
use App\Models\Student;
use App\Models\User;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class DoctorController
{
    use YPUSystemTrait;
    public function getStudentDoctors()
    {
        try {
            $user = Auth::user();

            $student = Student::where('user_id', $user->id)->first();

            if (!$student) {
                return $this->ErrorResponse('Student not found', 404);
            }

            $courseIds = $student->courses()->pluck('courses.id');

            if ($courseIds->isEmpty()) {
                return $this->ErrorResponse('No registered courses found', 404);
            }

            $doctorIds = DB::table('course_doctor')
                ->whereIn('course_id', $courseIds)
                ->pluck('doctor_id')
                ->unique();

            if ($doctorIds->isEmpty()) {
                return $this->ErrorResponse('No doctors found for your courses', 404);
            }

            $doctors = Doctor::with('user')->whereIn('id', $doctorIds)->get();

            return $this->SuccessResponse($doctors, 'Doctors retrieved successfully', 200);
        } catch (\Exception $e) {
            return $this->ErrorResponse($e->getMessage(), 500);
        }
    }

    public function getMyStudents()
    {
        try {
            $user = Auth::user();

            $doctor = Doctor::where('user_id', $user->id)->first();

            if (!$doctor) {
                return $this->ErrorResponse('Doctor not found', 404);
            }

            $courseIds = DB::table('course_doctor')
                ->where('doctor_id', $doctor->id)
                ->pluck('course_id');

            if ($courseIds->isEmpty()) {
                return $this->ErrorResponse('No courses found for this doctor', 404);
            }

            $studentIds = DB::table('course_student')
                ->whereIn('course_id', $courseIds)
                ->pluck('student_id')
                ->unique();

            if ($studentIds->isEmpty()) {
                return $this->ErrorResponse('No students found for your courses', 404);
            }

            $students = Student::with('user')
                ->whereIn('id', $studentIds)
                ->get();

            return $this->SuccessResponse($students, 'Students retrieved successfully', 200);
        } catch (\Exception $e) {
            return $this->ErrorResponse($e->getMessage(), 500);
        }
    }


     public function getAllDoctors()
     {
        $doctors = Doctor::with('user')->get();

        if ($doctors->isEmpty()) {
            return $this->ErrorResponse('No doctors found', 404);
        }

         return $this->SuccessResponse($doctors, 'Doctors retrieved successfully', 200);
     }

     public function AddDoctor(Request $request)
     {
         $validator = Validator::make($request->all(), [
             'name' => 'required|string',
             'email' => 'required|email|unique:users,email',
             'password' => 'required|string|min:6',
             'phone' => 'nullable|string',
             'device_token' => 'nullable|string',
             'role' => 'nullable|string',
             'x_location' => 'nullable|string',
             'y_location' => 'nullable|string',
             'z_location' => 'nullable|string',
             'profile_picture' => 'nullable|string',

             'specialization' => 'required|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $user = User::create([
             'name' => $request->name,
             'email' => $request->email,
             'password' => Hash::make($request->password),
             'phone' => $request->phone,
         ]);

         $doctor = Doctor::create([
             'user_id' => $user->id,
             'specialization' => $request->specialization,
         ]);

         return $this->SuccessResponse([
             'user' => $user,
             'doctor' => $doctor,
         ], 'Doctor and user created successfully', 201);
     }

     public function UpdateDoctor(Request $request, $id)
     {
         $doctor = Doctor::with('user')->find($id);

         if (!$doctor) {
             return $this->ErrorResponse('Doctor not found', 404);
         }

         $validator = Validator::make($request->all(), [
             'name' => 'nullable|string',
             'email' => 'nullable|email|unique:users,email,' . $doctor->user_id,
             'phone' => 'nullable|string',

             'specialization' => 'nullable|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $data = $request->only([
             'name', 'email', 'phone', 'device_token', 'role',
             'x_location', 'y_location', 'z_location', 'profile_picture',
         ]);

         if ($request->filled('password')) {
             $data['password'] = Hash::make($request->password);
         }

         $doctor->user->update($data);

         if ($request->filled('specialization')) {
             $doctor->update(['specialization' => $request->specialization]);
         }

         return $this->SuccessResponse([
             'user' => $doctor->user,
             'doctor' => $doctor,
         ], 'Doctor and user updated successfully', 200);
     }

     public function DeleteDoctor($id)
     {
         $doctor = Doctor::find($id);

         if (!$doctor) {
             return $this->ErrorResponse('Doctor not found', 404);
         }

         $user = $doctor->user;
         $doctor->delete();
         $user->delete();

         return $this->SuccessResponse(null, 'Doctor and user deleted successfully', 200);
     }

}
