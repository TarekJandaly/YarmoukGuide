<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chat extends Model
{
    protected $fillable = ['user_one', 'user_two'];

    public function messages()
    {
        return $this->hasMany(Message::class);
    }
    public function userOne()
    {
        return $this->belongsTo(User::class, 'user_one', 'id');
    }

    public function userTwo()
    {
        return $this->belongsTo(User::class, 'user_two', 'id');
    }
}
