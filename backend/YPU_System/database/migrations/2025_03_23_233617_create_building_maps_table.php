<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('building_maps', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // اسم الخريطة
            $table->string('dwg_file_path'); // مسار ملف DWG
            $table->string('json_file_path'); // مسار ملف JSON بعد التحويل
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('building_maps');
    }
};
