<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Notification;
use App\Models\User;
use App\Services\FcmNotificationService;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EventController
{
    use YPUSystemTrait;

    public function getAllEvents()
    {
        $events = Event::all();

        if ($events->isEmpty()) {
            return $this->ErrorResponse('No events found', 404);
        }

        return $this->SuccessResponse($events, 'Events retrieved successfully', 200);
    }



     public function AddEvent(Request $request,FcmNotificationService $fcmService)
     {
         $validator = Validator::make($request->all(), [
             'title' => 'required|string',
             'description' => 'nullable|string',
             'image' => 'nullable|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $event = Event::create([
             'title' => $request->title,
             'description' => $request->description,
             'image' => $request->image,
         ]);
        $targetRoles = ['student', 'doctor', 'employee'];
        $users = User::whereIn('role', $targetRoles)->get();

        foreach ($users as $user) {
            Notification::create([
                'user_id' => $user->id,
                'message' => '📢 New event: ' . $event->title,
            ]);

            $fcmService->sendFcmNotification(
                $user->id,
                '📢 New Event',
                $event->title
            );
        }
         return $this->SuccessResponse($event, 'Event created successfully', 201);
     }

     public function UpdateEvent(Request $request, $id)
     {
         $event = Event::find($id);

         if (!$event) {
             return $this->ErrorResponse('Event not found', 404);
         }

         $validator = Validator::make($request->all(), [
             'title' => 'nullable|string',
             'description' => 'nullable|string',
             'image' => 'nullable|string',
         ]);

         if ($validator->fails()) {
             return $this->ErrorResponse($validator->errors()->first(), 400);
         }

         $event->update($request->only(['title', 'description', 'image']));

         return $this->SuccessResponse($event, 'Event updated successfully', 200);
     }

     public function DeleteEvent($id)
     {
         $event = Event::find($id);

         if (!$event) {
             return $this->ErrorResponse('Event not found', 404);
         }

         $event->delete();

         return $this->SuccessResponse(null, 'Event deleted successfully', 200);
     }
}
