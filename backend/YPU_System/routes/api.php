<?php

use App\Http\Controllers\AnnouncementController;
use App\Http\Controllers\BuildingMapController;
use App\Http\Controllers\ChallengeController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\CourseController;
use App\Http\Controllers\DoctorController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\ExamController;
use App\Http\Controllers\ExerciseController;
use App\Http\Controllers\HallController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ProblemController;
use App\Http\Controllers\StudentController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\WorkoutPlanController;
use App\Http\Controllers\LocationController;
use App\Http\Middleware\CheckRole;
use App\Http\Middleware\RoleAdmin;
use App\Http\Middleware\RoleDoctor;
use App\Http\Middleware\RoleEmployee;
use App\Http\Middleware\RoleStudent;
use App\Models\BuildingMap;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);
Route::get('/get-all-announcements', [AnnouncementController::class, 'getAllAnnouncements']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/get-all-room', [HallController::class, 'getallroom']);
    Route::get('/get-all-event', [EventController::class, 'getAllEvents']);
    Route::get('/availableCourses', [CourseController::class, 'availableCourses']);
    Route::get('/get-notifications', [NotificationController::class, 'getUserNotifications']);
    Route::post('/update-profile', [UserController::class, 'updateProfile']);
    Route::post('/update-image-profile', [UserController::class, 'updateImageProfile']);
    Route::post('/create-chat', [ChatController::class, 'createChat']);
    Route::post('/send-message', [MessageController::class, 'sendMessage']);
    Route::get('/get-messages/{chat_id}', [MessageController::class, 'getMessages']);
    Route::get('/chats', [ChatController::class, 'getUserChats']);
    Route::get('/getStudentsAndDoctors', [UserController::class, 'getStudentsAndDoctors']);
    Route::post('/updateUserLocation', [UserController::class, 'updateUserLocation']);
    Route::post('/update-location', [LocationController::class, 'updateLocation']);

    
    Route::middleware(RoleStudent::class)->group(function () {
        Route::get('/get-student-doctors', [DoctorController::class, 'getStudentDoctors']);
        Route::get('/get-all-exams-student', [ExamController::class, 'getExamSchedule']);
        Route::get('/get-profile-student', [UserController::class, 'getProfileStudent']);
        Route::get('/get-student-courses', [CourseController::class, 'getStudentCourses']);
        Route::post('/registerMultipleCourses', [CourseController::class, 'registerMultipleCourses']);
    });

    Route::middleware(RoleDoctor::class)->group(function () {
        Route::get('/get-my-student', [DoctorController::class, 'getMyStudents']);
        Route::get('/get-profile-doctor', [UserController::class, 'getProfileDoctor']);
        Route::get('/get-doctor-courses', [CourseController::class, 'getDoctorLectures']);
        Route::get('/get-all-employee', [EmployeeController::class, 'getAllEmployees']);
        Route::get('/get-all-problems', [ProblemController::class, 'getAllProblems']);
        Route::post('/send-problem', [ProblemController::class, 'sendProblem']);
    });
    
    Route::middleware(RoleEmployee::class)->group(function () {
        Route::get('/get-profile-employee', [UserController::class, 'getProfileEmployee']);
        Route::get('/get-my-problems', [ProblemController::class, 'getMyProblems']);
        Route::post('/finish-problem/{id}', [ProblemController::class, 'finishProblem']);
    });

    Route::middleware(RoleAdmin::class)->group(function () {
        Route::post('/registerMultipleCourses/{id}', [CourseController::class, 'registerMultipleCoursesFormAdmin']);
        Route::get('/getScheduleStudentCourses/{id}', [CourseController::class, 'getScheduleStudentCourses']);
        Route::post('/assignCoursesToDoctor/{id}', [CourseController::class, 'assignCoursesToDoctor']);
        Route::get('/getScheduleDoctorLectures/{id}', [CourseController::class, 'getScheduleDoctorLectures']);
        Route::post('/uploadAndConvertMap', [BuildingMapController::class, 'uploadAndConvertMap']);
        Route::get('/getConvertedMap/{filename}', [BuildingMapController::class, 'getConvertedMap']);
        Route::get('/announcements', [AnnouncementController::class, 'getAllAnnouncements']);
        Route::post('/announcements', [AnnouncementController::class, 'AddAnnouncements']);
        Route::put('/announcements/{id}', [AnnouncementController::class, 'UpdateAnnouncements']);
        Route::delete('/announcements/{id}', [AnnouncementController::class, 'DeleteAnnouncements']);
        Route::get('/events', [EventController::class, 'getAllEvents']);
        Route::post('/events', [EventController::class, 'AddEvent']);
        Route::put('/events/{id}', [EventController::class, 'UpdateEvent']);
        Route::delete('/events/{id}', [EventController::class, 'DeleteEvent']);
        Route::get('/courses', [CourseController::class, 'getAllCourses']);
        Route::post('/courses', [CourseController::class, 'AddCourse']);
        Route::put('/courses/{id}', [CourseController::class, 'UpdateCourse']);
        Route::delete('/courses/{id}', [CourseController::class, 'DeleteCourse']);
        Route::get('/exams', [ExamController::class, 'getAllExams']);
        Route::post('/exams', [ExamController::class, 'AddExam']);
        Route::put('/exams/{id}', [ExamController::class, 'UpdateExam']);
        Route::delete('/exams/{id}', [ExamController::class, 'DeleteExam']);
        Route::get('/halls', [HallController::class, 'getAllHalls']);
        Route::post('/halls', [HallController::class, 'AddHall']);
        Route::put('/halls/{id}', [HallController::class, 'UpdateHall']);
        Route::delete('/halls/{id}', [HallController::class, 'DeleteHall']);
        Route::get('/doctors', [DoctorController::class, 'getAllDoctors']);
        Route::post('/doctors', [DoctorController::class, 'AddDoctor']);
        Route::put('/doctors/{id}', [DoctorController::class, 'UpdateDoctor']);
        Route::delete('/doctors/{id}', [DoctorController::class, 'DeleteDoctor']);
        Route::get('/students', [StudentController::class, 'getAllStudents']);
        Route::post('/students', [StudentController::class, 'AddStudent']);
        Route::put('/students/{id}', [StudentController::class, 'UpdateStudent']);
        Route::delete('/students/{id}', [StudentController::class, 'DeleteStudent']);
        Route::get('/employees', [EmployeeController::class, 'getAllEmployee']);
        Route::post('/employees', [EmployeeController::class, 'AddEmployee']);
        Route::put('/employees/{id}', [EmployeeController::class, 'UpdateEmployee']);
        Route::delete('/employees/{id}', [EmployeeController::class, 'DeleteEmployee']);
        Route::get('/images', [ImageController::class, 'getImages']);
        Route::post('/images', [ImageController::class, 'uplaodimages']);
        Route::delete('/images/{id}', [ImageController::class, 'deleteImage']);

    });
});


