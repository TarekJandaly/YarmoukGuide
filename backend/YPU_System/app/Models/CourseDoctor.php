<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CourseDoctor extends Model
{
    use HasFactory;

    protected $table = 'course_doctor';

    public $timestamps = true;

    protected $fillable = ['course_id', 'doctor_id'];
}
