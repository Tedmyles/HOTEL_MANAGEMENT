import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/hotel2.dart';
import 'package:flutter_application_2/screens/room_details.dart';
import 'package:flutter_application_2/screens/manage_rooms.dart';

class ViewHotelsScreen extends StatefulWidget {
  const ViewHotelsScreen({Key? key}) : super(key: key);

  @override
  _ViewHotelsScreenState createState() => _ViewHotelsScreenState();
}

class _ViewHotelsScreenState extends State<ViewHotelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Hotels'),
      ),
      body: buildHotelList(),
    );
  }

  Future<List<Hotel>> fetchHotels() async {
    final hotelsCollection = FirebaseFirestore.instance.collection('hotels');
    final hotelsSnapshot = await hotelsCollection.get();
    
    return hotelsSnapshot.docs.map((hotelDoc) {
      final hotelData = hotelDoc.data() as Map<String, dynamic>;
      return Hotel.fromMap(hotelData, hotelDoc.id);
    }).toList();
  }

  Widget buildHotelList() {
    return FutureBuilder<List<Hotel>>(
      future: fetchHotels(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final hotels = snapshot.data!;
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            return ListTile(
              title: Text(hotel.name),
              subtitle: Text(hotel.location),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(hotel);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomsScreen(hotelId: hotel.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(Hotel hotel) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${hotel.name}?'),
          content: Text('Are you sure you want to delete ${hotel.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteHotel(hotel);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteHotel(Hotel hotel) async {
    try {
      final hotelRef = FirebaseFirestore.instance.collection('hotels').doc(hotel.id);
      await hotelRef.delete();
      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${hotel.name} deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting ${hotel.name}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
