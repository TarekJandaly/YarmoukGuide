<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Employee;
use App\Models\Notification;
use App\Models\Problem;
use App\Services\FcmNotificationService;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProblemController
{
    use YPUSystemTrait;

    public function getAllProblems()
    {
        $user=Auth::user();
        $doctor=Doctor::where("user_id",$user->id)->first();
        $problems = Problem::where('doctor_id',$doctor->id)->get();

        if ($problems->isEmpty()) {
            return $this->ErrorResponse('No problems found', 404);
        }

        return $this->SuccessResponse($problems, 'Problems retrieved successfully', 200);
    }

    public function getMyProblems()
    {
        $user=Auth::user();
        $employee=Employee::where("user_id",$user->id)->first();
        $problems = Problem::where('employee_id',$employee->id)->get();

        if ($problems->isEmpty()) {
            return $this->ErrorResponse('No problems found', 404);
        }

        return $this->SuccessResponse($problems, 'Problems retrieved successfully', 200);
    }


    public function finishProblem($id)
    {
        $user=Auth::user();
        $employee=Employee::where("user_id",$user->id)->first();
        $problem = Problem::find($id);
        if ($problem->status) {
            return $this->ErrorResponse( 'The problem is already fixed.', 403);

        }
        if ($problem->employee_id==$employee->id) {
            $problem->status=1;
            $problem->save();
        }else{
            return $this->ErrorResponse( 'You do not have the authority to fix the problem.', 403);
        }


        return $this->SuccessResponse($problem, 'Problem finish successfully', 200);
    }


    public function sendProblem(Request $request,FcmNotificationService $fcmService)
    {
        $user = Auth::user();
        $doctor = Doctor::where("user_id", $user->id)->first();

        if (!$doctor) {
            return $this->ErrorResponse("Doctor not found", 404);
        }

        $request->validate([
            'description' => 'required|string|max:1000',
            'employee_id' => 'required|exists:employees,id',
        ]);

        $problem = Problem::create([
            'description' => $request->description,
            'doctor_id' => $doctor->id,
            'employee_id' => $request->employee_id,
        ]);
        $employee=Employee::find($request->employee_id);
        Notification::create([
            'user_id' => $employee->user_id,
            'message' => 'You have a new problem to fix it',

        ]);
        $fcmService->sendFcmNotification(
            $employee->user_id,
            'Problem',
            'You have a new problem to fix it'
        );


        return $this->SuccessResponse($problem, "Problem sent successfully", 201);
    }
}
