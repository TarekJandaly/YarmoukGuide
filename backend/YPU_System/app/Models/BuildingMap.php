<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BuildingMap extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'dwg_file_path',
        'json_file_path',
    ];
}
