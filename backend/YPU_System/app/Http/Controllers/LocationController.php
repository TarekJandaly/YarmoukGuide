<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Events\UserLocationUpdated;
use App\Models\User;

class LocationController extends Controller
{
    public function updateLocation(Request $request)
    {
        $request->validate([
            //'user_id' => 'required|exists:users,id',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'altitude' => 'required|numeric',
        ]);

        $user = User::find($request->user_id);
        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        // بث التحديث عبر Pusher
        broadcast(new UserLocationUpdated($request->user_id, $request->latitude, $request->longitude, $request->altitude))->toOthers();

        return response()->json(['message' => 'Location updated successfully']);
    }
}
