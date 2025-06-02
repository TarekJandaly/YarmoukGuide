<?php

namespace App\Traits;

trait YPUSystemTrait
{
    public function SuccessResponse($data=null,$message=null,$code=null)
    {
        $array=[
            'data'=>$data,
            'message'=>$message,
            'code'=>$code
        ];
        return response($array,$code);
    }

    public function ErrorResponse($message=null,$code=null)
    {
        $array=[
            'message'=>$message,
            'code'=>$code
        ];
        return response($array,$code);
    }
}

