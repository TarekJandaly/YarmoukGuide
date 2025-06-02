<?php

namespace App\Http\Controllers;

use App\Models\Student;
use App\Models\User;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class StudentController
{
    use YPUSystemTrait;
        public function getAllStudents()
        {
            $students = Student::with('user')->get();

            if ($students->isEmpty()) {
                return $this->ErrorResponse('No students found', 404);
            }

            return $this->SuccessResponse($students, 'Students retrieved successfully', 200);
        }

        public function AddStudent(Request $request)
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

                'university_number' => 'required|string|unique:students,university_number',
                'registered_year' => 'required|integer',
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
                'device_token' => $request->device_token,
                'role' => 'student', // 👈 ثابتة
                'x_location' => $request->x_location,
                'y_location' => $request->y_location,
                'z_location' => $request->z_location,
                'profile_picture' => $request->profile_picture,
            ]);

            $student = Student::create([
                'user_id' => $user->id,
                'university_number' => $request->university_number,
                'registered_year' => $request->registered_year,
                'specialization' => $request->specialization,
            ]);

            return $this->SuccessResponse([
                'user' => $user,
                'student' => $student,
            ], 'Student and user created successfully', 201);
        }

        public function UpdateStudent(Request $request, $id)
        {
            $student = Student::with('user')->find($id);

            if (!$student) {
                return $this->ErrorResponse('Student not found', 404);
            }

            $validator = Validator::make($request->all(), [
                'name' => 'nullable|string',
                'email' => 'nullable|email|unique:users,email,' . $student->user_id,
                'password' => 'nullable|string|min:6',
                'phone' => 'nullable|string',
                'device_token' => 'nullable|string',
                'role' => 'nullable|string',
                'x_location' => 'nullable|string',
                'y_location' => 'nullable|string',
                'z_location' => 'nullable|string',
                'profile_picture' => 'nullable|string',

                'university_number' => 'nullable|string|unique:students,university_number,' . $student->id,
                'registered_year' => 'nullable|integer',
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

            $student->user->update($data);

            $studentData = $request->only(['university_number', 'registered_year', 'specialization']);
            $student->update($studentData);

            return $this->SuccessResponse([
                'user' => $student->user,
                'student' => $student,
            ], 'Student and user updated successfully', 200);
        }

        public function DeleteStudent($id)
        {
            $student = Student::find($id);

            if (!$student) {
                return $this->ErrorResponse('Student not found', 404);
            }

            $user = $student->user;
            $student->delete();
            $user->delete();

            return $this->SuccessResponse(null, 'Student and user deleted successfully', 200);
        }
}
