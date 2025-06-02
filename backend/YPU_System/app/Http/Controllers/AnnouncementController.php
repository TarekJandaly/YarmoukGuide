<?php

namespace App\Http\Controllers;

use App\Models\Announcement;
use App\Models\Notification;
use App\Models\User;
use App\Services\FcmNotificationService;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AnnouncementController
{
    use YPUSystemTrait;
     public function getAllAnnouncements()
     {
         $announcements = Announcement::all();

         if ($announcements->isEmpty()) {
             return $this->ErrorResponse('No announcements found', 404);
         }

         return $this->SuccessResponse($announcements, 'Announcements retrieved successfully', 200);
     }

    public function AddAnnouncements(Request $request,FcmNotificationService $fcmService)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string',
            'description' => 'required|string',
            'image' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->ErrorResponse($validator->errors()->first(), 400);
        }

        $announcement = Announcement::create([
            'title' => $request->title,
            'description' => $request->description,
            'image' => $request->image,
        ]);
         $targetRoles = ['student', 'doctor', 'employee'];
         $users = User::whereIn('role', $targetRoles)->get();

         foreach ($users as $user) {
             Notification::create([
                 'user_id' => $user->id,
                 'message' => '📢 New announcement: ' . $announcement->title,
             ]);

             $fcmService->sendFcmNotification(
                 $user->id,
                 '📢 New announcement',
                 $announcement->title
             );
         }

        return $this->SuccessResponse($announcement, 'Announcement added successfully', 201);
    }

    public function UpdateAnnouncements(Request $request, $id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return $this->ErrorResponse('Announcement not found', 404);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'nullable|string',
            'description' => 'nullable|string',
            'image' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->ErrorResponse($validator->errors()->first(), 400);
        }

        $announcement->update($request->only(['title', 'description', 'image']));

        return $this->SuccessResponse($announcement, 'Announcement updated successfully', 200);
    }

    public function DeleteAnnouncements($id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return $this->ErrorResponse('Announcement not found', 404);
        }

        $announcement->delete();

        return $this->SuccessResponse(null, 'Announcement deleted successfully', 200);
    }
}
