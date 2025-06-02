import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/View/Room/Controller/RoomControlller.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomControlller>(
      builder: (context, controller, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Room List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Find a room...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: controller.filterRooms,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = controller.filteredRooms[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(room.name!),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () =>
                              controller.showRoomOptions(context, room),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Map_Screen extends StatelessWidget {
  final String room;

  const Map_Screen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show path to $room'),
      ),
      body: Center(
        child: Text(
          'The path to $room is displayed here..',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
