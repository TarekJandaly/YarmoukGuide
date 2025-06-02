<?php

namespace App\Http\Controllers;

use App\Models\Chat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatController
{
       public function createChat(Request $request)
       {

         $user=Auth::user();
           $request->validate([
               'to' => 'required|exists:users,id',
           ]);

           $chat = Chat::where(function ($query) use ($request,$user) {
               $query->where('user_one', $user->id)
                     ->where('user_two', $request->to);
           })->orWhere(function ($query) use ($request,$user) {
               $query->where('user_two', $user->id)
                     ->where('user_one', $request->to);
           })->first();

           if (!$chat) {
               $chat = Chat::create([
                   'user_one' => $user->id,
                   'user_two' => $request->to,
               ]);
           }

           return response()->json($chat);
       }
     public function getUserChats()
     {
         $userId = Auth::id();

         $chats = Chat::where('user_one', $userId)
                     ->orWhere('user_two', $userId)
                     ->with(['userOne', 'userTwo'])
                     ->get()
                     ->map(function ($chat) use ($userId) {
                         $otherUser = $chat->user_one == $userId ? $chat->userTwo : $chat->userOne;

                         return [
                             'chat_id' => $chat->id,
                             'other_user' => $otherUser ? $otherUser->name : 'Unknown',
                             'other_user_id' => $otherUser ? $otherUser->id : null,
                             'created_at' => $chat->created_at,
                         ];
                     });

         return response()->json($chats);
     }
}
