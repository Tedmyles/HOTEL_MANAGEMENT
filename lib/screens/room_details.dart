import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/room.dart';
import 'package:flutter_application_2/screens/booking_screen.dart'; // Import the BookingScreen

class RoomDetailsScreen extends StatelessWidget {
  final String hotelId;
  final String roomId;

  const RoomDetailsScreen({Key? key, required this.hotelId, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('hotels')
            .doc(hotelId)
            .collection('rooms')
            .doc(roomId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading room details.'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Room not found.'));
          } else {
            final roomData = snapshot.data!.data() as Map<String, dynamic>;
            final room = Room.fromMap(roomData, snapshot.data!.id);

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Display room image if available, otherwise show a placeholder
                            room.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      room.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Placeholder(),
                            const SizedBox(height: 16.0),
                            // Display room type
                            Text(
                              'Room Type: ${room.type}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            // Display room price
                            Text('Price: Ksh${room.price.toStringAsFixed(2)}'),
                            const SizedBox(height: 8.0),
                            // Display room availability
                            Text('Availability: ${room.isAvailable ? 'Available' : 'Not Available'}'),
                            // Show "Book Now" button if the room is available
                            if (room.isAvailable)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingScreen(
                                        hotelId: hotelId,
                                        roomId: roomId,
                                        roomPrice: room.price,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Book Now'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
