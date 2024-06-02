import 'package:flutter/foundation.dart'; // Import for ChangeNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/hotel.dart';


class HotelProvider extends ChangeNotifier { // Extend ChangeNotifier
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHotel(Hotel hotel) async {
    try {
      await _firestore.collection('hotels').add({
        'name': hotel.name,
        'location': hotel.location,
        'imageUrl': hotel.imageUrl,
        'rating': hotel.rating,
        // 'rooms': hotel.rooms.map((room) => {
        //   'type': room.type,
        //   'rate': room.rate,
        //   'isAvailable': room.isAvailable,
        //   'price': room.price,
        // }).toList(),
      });
      notifyListeners(); // Notify listeners of changes
    } catch (e) {
      // ignore: avoid_print
      print('Error adding hotel: $e');
    }
  }

  // Add other methods as necessary and call notifyListeners() after updates
}
