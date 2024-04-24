import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data/hotel_data.dart';
import 'package:flutter_application_2/domain/models/hotel.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  const RoomDetailsScreen({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Type: ${room.type}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Rate: \$${room.rate.toStringAsFixed(2)}'), // Escaping the dollar sign
            SizedBox(height: 8.0),
            Text('Availability: ${room.isAvailable ? 'Available' : 'Not Available'}'),
            // Add more details about the room here
          ],
        ),
      ),
    );
  }
}
