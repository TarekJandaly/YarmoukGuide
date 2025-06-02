<?php

namespace App\Http\Controllers;

use App\Events\NewMessageEvent;
use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MessageController
{
    public function sendMessage(Request $request)
    {
        $user=Auth::user();
        $message = Message::create([
            'chat_id' => $request->chat_id,
            'sender_id' => $user->id,
            'message' => $request->message,
        ]);

        broadcast(new NewMessageEvent($message))->toOthers();


        return response()->json($message);
    }

    public function getMessages($chat_id)
    {
        $messages = Message::where('chat_id', $chat_id)->orderBy('created_at')->get();
        return response()->json($messages);
    }
}
