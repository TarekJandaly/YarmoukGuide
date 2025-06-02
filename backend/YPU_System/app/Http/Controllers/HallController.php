<?php

namespace App\Http\Controllers;

use App\Models\Hall;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class HallController
{
    use YPUSystemTrait;
     public function getallroom(Request $request) {
        $rooms = Hall::with('courses')->get();
        return $this->SuccessResponse($rooms,'Rooms Retrived successfully', 200);
    }

       public function getAllHalls()
       {
           $halls = Hall::all();

           if ($halls->isEmpty()) {
               return $this->ErrorResponse('No halls found', 404);
           }

           return $this->SuccessResponse($halls, 'Halls retrieved successfully', 200);
       }

       public function AddHall(Request $request)
       {
           $validator = Validator::make($request->all(), [
               'name' => 'required|string',
           ]);

           if ($validator->fails()) {
               return $this->ErrorResponse($validator->errors()->first(), 400);
           }

           $hall = Hall::create([
               'name' => $request->name,
           ]);

           return $this->SuccessResponse($hall, 'Hall created successfully', 201);
       }

       public function UpdateHall(Request $request, $id)
       {
           $hall = Hall::find($id);

           if (!$hall) {
               return $this->ErrorResponse('Hall not found', 404);
           }

           $validator = Validator::make($request->all(), [
               'name' => 'nullable|string',
           ]);

           if ($validator->fails()) {
               return $this->ErrorResponse($validator->errors()->first(), 400);
           }

           $hall->update($request->only(['name']));

           return $this->SuccessResponse($hall, 'Hall updated successfully', 200);
       }

       public function DeleteHall($id)
       {
           $hall = Hall::find($id);

           if (!$hall) {
               return $this->ErrorResponse('Hall not found', 404);
           }

           $hall->delete();

           return $this->SuccessResponse(null, 'Hall deleted successfully', 200);
       }
}
