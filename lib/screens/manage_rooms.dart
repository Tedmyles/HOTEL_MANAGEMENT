import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/room.dart';

class RoomsScreen extends StatefulWidget {
  final String hotelId;

  const RoomsScreen({Key? key, required this.hotelId}) : super(key: key);

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: buildRoomList(),
    );
  }

  Future<List<Room>> fetchRooms() async {
    final roomsCollection = FirebaseFirestore.instance
        .collection('hotels')
        .doc(widget.hotelId)
        .collection('rooms');
    final roomsSnapshot = await roomsCollection.get();

    return roomsSnapshot.docs.map((roomDoc) {
      final roomData = roomDoc.data() as Map<String, dynamic>;
      return Room.fromMap(roomData, roomDoc.id);
    }).toList();
  }

  Widget buildRoomList() {
    return FutureBuilder<List<Room>>(
      future: fetchRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching rooms'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No rooms found'));
        }
        rooms = snapshot.data!;
        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return ListTile(
              leading: room.imageUrl.isNotEmpty ? Image.network(room.imageUrl, width: 50, height: 50, fit: BoxFit.cover) : null,
              title: Text(room.type),
              subtitle: Text('Price: \$${room.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditRoomDialog(room);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(room);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Navigate to room details screen if necessary
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showEditRoomDialog(Room room) async {
    final TextEditingController priceController = TextEditingController(text: room.price.toString());
    bool isAvailable = room.isAvailable;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${room.type}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SwitchListTile(
                title: Text('Available'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateRoom(room, double.tryParse(priceController.text) ?? room.price, isAvailable);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRoom(Room room, double newPrice, bool newAvailability) async {
    try {
      final roomRef = FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotelId)
          .collection('rooms')
          .doc(room.id);

      await roomRef.update({
        'price': newPrice,
        'isAvailable': newAvailability,
      });

      // Create a new instance of Room with updated values
      final updatedRoom = Room(
        id: room.id,
        type: room.type,
        isAvailable: newAvailability,
        price: newPrice,
        imageUrl: room.imageUrl,
      );

      setState(() {
        final index = rooms.indexWhere((r) => r.id == room.id);
        rooms[index] = updatedRoom;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${room.type} updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating ${room.type}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(Room room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${room.type}?'),
          content: Text('Are you sure you want to delete ${room.type}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteRoom(room);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRoom(Room room) async {
    try {
      final roomRef = FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotelId)
          .collection('rooms')
          .doc(room.id);
      await roomRef.delete();

      setState(() {
        rooms.removeWhere((r) => r.id == room.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${room.type} deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting ${room.type}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
