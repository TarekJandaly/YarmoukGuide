<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class RoleStudent
{

    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();

        if (!$user || $user->role != 'student') {
            return response()->json(['message' => 'Unauthorized Access'], 403);
        }

        return $next($request);
    }
}
