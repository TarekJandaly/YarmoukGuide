import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/url.dart';
import 'package:ypu_dashboard/View/Admin/Map/Controller/MapController.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapController>(
      builder: (context, controller, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          controller.pickedFile == null
                              ? 'No file selected'
                              : 'Selected file: ${controller.pickedFile!.name}',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: controller.pickFile,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16)),
                      child: const Text('Pick File'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Wrap buttons nicely
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: controller.isUploading
                          ? null
                          : () => controller.uploadFile(context),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16)),
                      child: const Text('Upload & Convert'),
                    ),
                    ElevatedButton(
                      onPressed: controller.pickImages,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16)),
                      child: const Text('Pick Images'),
                    ),
                    ElevatedButton(
                      onPressed: controller.isUploadingimage
                          ? null
                          : () => controller.uploadimages(context),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16)),
                      child: const Text('Upload Image'),
                    ),
                    if (controller.isUploading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                    if (controller.jsonFilePath != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          controller.jsonFilePath!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ],
                ),

                if (controller.pickedimages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.basic,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.active),
                      ),
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: controller.pickedimages
                              .map((file) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Image.memory(file.bytes!),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),

                if (controller.listImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.basic,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.active),
                      ),
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: controller.listImages
                              .map((image) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            height: 300,
                                            "${AppApi.urlImage}${image.path!}",
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () =>
                                              controller.DeleteImages(
                                                  context, image.id!),
                                          child: const Text("Delete"),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
