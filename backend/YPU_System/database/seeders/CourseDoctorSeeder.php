<?php

namespace Database\Seeders;

use App\Models\Course;
use App\Models\CourseDoctor;
use App\Models\Doctor;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CourseDoctorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         $courses = Course::all();
         $doctors = Doctor::all();

         foreach ($courses as $course) {
            $randomDoctor = $doctors->random();
             CourseDoctor::create([
                'course_id' => $course->id,
                'doctor_id' => $randomDoctor->id,
            ]);

         }
    }
}
