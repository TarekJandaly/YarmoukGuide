<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class UserLocationUpdated implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    //public $user_id;
    public $latitude;
    public $longitude;
    public $altitude;

    public function __construct( $latitude, $longitude, $altitude)
    {
        //$this->user_id = $user_id;
        $this->latitude = $latitude;
        $this->longitude = $longitude;
        $this->altitude = $altitude;
    }

    public function broadcastOn()
    {
        return new Channel('location-updates'); // يجب أن يكون نفس القناة في Unity
    }

    public function broadcastAs()
    {
        return 'user-location-updated'; // يجب أن يكون نفس الحدث في Unity
    }
}
