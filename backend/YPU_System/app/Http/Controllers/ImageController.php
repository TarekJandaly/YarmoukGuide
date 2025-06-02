<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Image;
use App\Traits\YPUSystemTrait;
use Illuminate\Support\Facades\Storage;

class ImageController
{
    use YPUSystemTrait;

    public function uplaodimages(Request $request)
    {

        // التحقق من صحة الصور
        $validatedData = $request->validate([
            'images.*' => 'required|image|mimes:jpeg,png,jpg,gif',
        ]);

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $imageFile) {
                // تخزين الصورة
                $path = $imageFile->store('images_map', 'public');

                // حفظ الصورة بقاعدة البيانات
                Image::create([
                    'path' => $path,
                ]);
            }
        }

        return $this->SuccessResponse(null,'Images uploaded successfully',200);
    }

    public function getImages()
    {
        $images = Image::all();

        return $this->SuccessResponse($images, 'Images retrieved successfully', 200);
    }


    public function deleteImage($id)
    {
        $image = Image::find($id);

        // تحقق من وجود الصورة
        if ($image) {
            // حذف الصورة من السيرفر باستخدام المسار الصحيح
            Storage::disk('public')->delete($image->path); // هنا تأكد من أنك تستخدم المسار الخاص بالصورة

            // حذف السجل من قاعدة البيانات
            $image->delete();

            return $this->SuccessResponse(null, 'Image deleted successfully', 200);
        }

        return $this->ErrorResponse('Image not found', 404); // في حال الصورة غير موجودة
    }

}
