<?php

namespace App\Http\Controllers;

use App\Services\FcmNotificationService;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController
{
    use YPUSystemTrait;
    protected $fcmService;

    public function __construct(FcmNotificationService $fcmService)
    {
        $this->fcmService = $fcmService;
    }

    public function notifyUser(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'title' => 'required|string',
            'body' => 'required|string',
        ]);

        $response = $this->fcmService->sendFcmNotification(
            $request->user_id,
            $request->title,
            $request->body
        );

        return response()->json([
            'message' => 'Notification sent successfully',
            'response' => $response,
        ]);
    }

    public function getUserNotifications(Request $request)
    {
        $user = Auth::user();
        $notifications = $user->notifications()->latest()->get();

        return $this->SuccessResponse($notifications,'User notifications fetched successfully',200);
    }
}
