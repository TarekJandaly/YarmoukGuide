import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/View/Map/Controller/MapController.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Center(
              //   child: FutureBuilder(
              //     future: controller.GetStudentsAndDoctors(context),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const CircularProgressIndicator();
              //       }
              //       return Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             controller.is3DView ? "View 3D map" : "2D map view",
              //             style: const TextStyle(
              //                 fontSize: 18, fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
              Positioned(
                top: 20,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () => controller.showMenu(context),
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.menu),
                    ),
                    if (ServicesProvider.getRole() != "employee")
                      const SizedBox(height: 10),
                    if (ServicesProvider.getRole() != "employee")
                      FloatingActionButton(
                        onPressed: () => controller.showusersdialog(context),
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.person_search),
                      ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () => controller.scanImage(context),
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.camera_alt),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () =>
                          controller.UpdateUserLocation(654, 5564, 8798),
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.refresh),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
