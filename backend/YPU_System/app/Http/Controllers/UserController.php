<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Employee;
use App\Models\Student;
use App\Models\User;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
    use YPUSystemTrait;

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'          => 'required|string|max:255',
            'email'         => 'required|email|unique:users,email',
            'password'      => 'required|string|min:8',
            'phone'         => 'required|string|max:20|unique:users,phone',
            'role'          => 'required|in:student,doctor,employee',

            'university_number' => 'required_if:role,student|nullable|string|unique:students,university_number',
            'registered_year'   => 'required_if:role,student|nullable|integer',
            'specialization'    => 'required_if:role,student,doctor|nullable|string',
            'department'        => 'required_if:role,employee|nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->ErrorResponse($validator->errors(), 422);
        }

        $user = User::create([
            'name'         => $request->name,
            'email'        => $request->email,
            'password'     => Hash::make($request->password),
            'phone'        => $request->phone,
            'role'         => $request->role,
        ]);

        if ($request->role === 'student') {
            Student::create([
                'user_id'          => $user->id,
                'university_number'=> $request->university_number,
                'registered_year'  => $request->registered_year,
                'specialization'   => $request->specialization,
            ]);
        } elseif ($request->role === 'doctor') {
            Doctor::create([
                'user_id'        => $user->id,
                'specialization' => $request->specialization,
            ]);
        } elseif ($request->role === 'employee') {
            Employee::create([
                'user_id'   => $user->id,
                'department'=> $request->department,
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->SuccessResponse(
            [
                'user' => $user,
                'token' => $token
            ],
            "User registered successfully",
            201
        );
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string|min:8',
            'device_token' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->ErrorResponse(['errors' => $validator->errors()], 422);
        }

        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            if ($request->has('device_token')) {
                $user->device_token = $request->device_token;
                $user->save();
            }
            $token = $user->createToken('auth_token')->plainTextToken;
            $data = [
                'token' => $token,
                'role' => $user->role,
            ];
            return $this->SuccessResponse($data,"Login successful", 200);
        }


        return $this->ErrorResponse('Invalid credentials', 401);
    }



    public function getProfileStudent(Request $request)
    {
        $user=Auth::user();

        $profile = User::where('id', $user->id)
        ->with('student')
        ->first();
        return $this->SuccessResponse($profile,'Profile retrived successfully',200 );
    }



    public function getProfileDoctor(Request $request)
    {
        $user=Auth::user();

        $profile = User::where('id', $user->id)
        ->with('doctor')
        ->first();
        return $this->SuccessResponse($profile,'Profile retrived successfully',200 );
    }

    public function getProfileEmployee(Request $request)
    {
        $user=Auth::user();

        $profile = User::where('id', $user->id)
        ->with('employee')
        ->first();
        return $this->SuccessResponse($profile,'Profile retrived successfully',200 );
    }

    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $validatedData = $request->validate([
            'name' => 'nullable|string|max:255',
            'email' => 'nullable|email|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|unique:users,phone,' . $user->id,
        ]);

        $user->update($request->only(['name', 'email', 'phone']));


            $user->save();

        return $this->SuccessResponse([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'profile_picture' => $user->profile_picture ,
            ]
        ], 'Profile updated successfully', 200);
    }


    public function updateImageProfile(Request $request)
    {
        $user = Auth::user();

        $validatedData = $request->validate([
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);
        if ($request->hasFile('profile_picture')) {
            if ($user->profile_picture) {
                Storage::disk('public')->delete($user->profile_picture);
            }

            $imagePath = $request->file('profile_picture')->store('profile_images', 'public');
            $user->profile_picture = $imagePath;
            $user->save();
        }

        return $this->SuccessResponse([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'profile_picture' => $user->profile_picture ,
            ]
        ], 'Profile Image updated successfully', 200);
    }

    public function getStudentsAndDoctors()
    {
        try {
            $users = User::whereIn('role', ['student', 'doctor'])
                ->with(['student', 'doctor'])
                ->get();

            return $this->SuccessResponse($users, 'Users fetched successfully',200);
        } catch (\Exception $e) {
            return $this->ErrorResponse($e->getMessage(), 500);
        }
    }

    public function updateUserLocation(Request $request)
    {
        $user=Auth::user();
        $validator = Validator::make($request->all(), [
            'x_location' => 'required|numeric',
            'y_location' => 'required|numeric',
            'z_location' => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return $this->ErrorResponse(['error' => $validator->errors()], 422);
        }

        $user->update([
            'x_location' => $request->x_location,
            'y_location' => $request->y_location,
            'z_location' => $request->z_location,
        ]);

        return $this->SuccessResponse($user,'Location updated successfully', 200);
    }

}
