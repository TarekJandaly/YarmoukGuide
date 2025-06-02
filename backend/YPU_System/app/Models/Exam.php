<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Exam extends Model
{
    use HasFactory;

    protected $fillable = ['course_id', 'exam_date', 'exam_time'];

    public function course(): BelongsTo
    {
        return $this->belongsTo(Course::class);
    }
}
