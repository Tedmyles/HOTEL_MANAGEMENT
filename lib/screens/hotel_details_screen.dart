import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/hotel.dart';
import 'package:flutter_application_2/domain/models/room.dart';
import 'package:flutter_application_2/screens/room_details.dart';

class HotelDetailsScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailsScreen({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('hotels')
            .doc(hotel.id)
            .collection('rooms')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading rooms.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rooms found.'));
          } else {
            final roomDocs = snapshot.data!.docs;

            return ListView(
              children: roomDocs.map((roomDoc) {
                final roomData = roomDoc.data() as Map<String, dynamic>;
                final room = Room.fromMap(roomData, roomDoc.id);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                          child: Image.network(
                            room.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text(room.type),
                          subtitle: Text('Price: Ksh${room.price.toStringAsFixed(2)}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomDetailsScreen(
                                  hotelId: hotel.id,
                                  roomId: room.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
