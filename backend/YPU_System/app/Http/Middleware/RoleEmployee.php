<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class RoleEmployee
{

    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();

        if (!$user || $user->role != 'employee') {
            return response()->json(['message' => 'Unauthorized Access'], 403);
        }

        return $next($request);
    }
}
