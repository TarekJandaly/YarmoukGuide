<?php

namespace App\Http\Controllers;

use App\Models\BuildingMap;
use App\Traits\YPUSystemTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class BuildingMapController
{
    use YPUSystemTrait;

   
    public function uploadAndConvertMap(Request $request)
    {
        try {
            $request->validate([
                'name' => 'required|string',
                'map_file' => 'required|file',
            ]);

            $existingMap = BuildingMap::first();
            if ($existingMap) {
                Storage::disk('public')->delete([$existingMap->dwg_file_path, $existingMap->json_file_path]);
                $existingMap->delete();
            }

            $mapFile = $request->file('map_file');
            $fileName = time() . '_' . $mapFile->getClientOriginalName();
            $filePath = $mapFile->storeAs('maps', $fileName, 'public');

            $jsonFileName = pathinfo($fileName, PATHINFO_FILENAME) . '.json';
            $jsonPath = storage_path("app/public/maps/$jsonFileName");
            $inputFile = storage_path("app/public/maps/$fileName");

            if ($mapFile->getClientOriginalExtension() === 'dxf') {
                $env = [
                    'USERPROFILE' => 'C:\\Users\\tarek',
                    'HOME' => 'C:\\Users\\tarek',
                ];

                $python = 'C:\\Users\\tarek\\AppData\\Local\\Programs\\Python\\Python312\\python.exe';
                $script = 'C:\\Users\\tarek\\MyPythonProject\\scripts\\dwg_to_json.py';

                Log::info("Running Python Command: $python $script $inputFile $jsonPath");

                $process = new Process([
                    $python,
                    $script,
                    $inputFile,
                    $jsonPath,
                ], base_path(), $env);

                $process->run();

                Log::info('Python Command Output: ' . $process->getOutput());
                Log::error('Python Command Error: ' . $process->getErrorOutput());

                if (!$process->isSuccessful()) {
                    throw new ProcessFailedException($process);
                }
            }



         return response()->json([
             'message' => 'تم رفع وتحويل الخريطة بنجاح ✅',
             'json_path' => $mapFile->getClientOriginalExtension() === 'dxf' ? asset("storage/maps/$jsonFileName") : null,

         ], 201);
        
        } catch (\Exception $e) {
            Log::error('Map Conversion Error: ' . $e->getMessage());
            return $this->ErrorResponse($e->getMessage(), 500);
        }
    }


    
 }
