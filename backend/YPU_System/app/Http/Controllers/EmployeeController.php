<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use App\Models\User;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class EmployeeController
{
    use YPUSystemTrait;

    public function getAllEmployees()
    {
        $employees = User::where('role','employee')->with('employee')->get();

        if ($employees->isEmpty()) {
            return $this->ErrorResponse('No employees found', 404);
        }

        return $this->SuccessResponse($employees, 'Employees retrieved successfully', 200);
    }



    public function getAllEmployee()
    {
        $employees = Employee::with('user')->get();

        if ($employees->isEmpty()) {
            return $this->ErrorResponse('No employees found', 404);
        }

        return $this->SuccessResponse($employees, 'Employees retrieved successfully', 200);
    }

    public function AddEmployee(Request $request)
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

            'department' => 'required|string',
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
            'role' => 'employee', // 👈 ثابتة
            'x_location' => $request->x_location,
            'y_location' => $request->y_location,
            'z_location' => $request->z_location,
            'profile_picture' => $request->profile_picture,
        ]);

        $employee = Employee::create([
            'user_id' => $user->id,
            'department' => $request->department,
        ]);

        return $this->SuccessResponse([
            'user' => $user,
            'employee' => $employee,
        ], 'Employee and user created successfully', 201);
    }

    public function UpdateEmployee(Request $request, $id)
    {
        $employee = Employee::with('user')->find($id);

        if (!$employee) {
            return $this->ErrorResponse('Employee not found', 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'email' => 'nullable|email|unique:users,email,' . $employee->user_id,
            'password' => 'nullable|string|min:6',
            'phone' => 'nullable|string',
            'device_token' => 'nullable|string',
            'role' => 'nullable|string',
            'x_location' => 'nullable|string',
            'y_location' => 'nullable|string',
            'z_location' => 'nullable|string',
            'profile_picture' => 'nullable|string',

            'department' => 'nullable|string',
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

        $employee->user->update($data);

        $employeeData = $request->only(['department']);
        $employee->update($employeeData);

        return $this->SuccessResponse([
            'user' => $employee->user,
            'employee' => $employee,
        ], 'Employee and user updated successfully', 200);
    }

    public function DeleteEmployee($id)
    {
        $employee = Employee::find($id);

        if (!$employee) {
            return $this->ErrorResponse('Employee not found', 404);
        }

        $user = $employee->user;
        $employee->delete();
        $user->delete();

        return $this->SuccessResponse(null, 'Employee and user deleted successfully', 200);
    }
}
