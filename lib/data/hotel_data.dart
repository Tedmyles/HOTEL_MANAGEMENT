import 'package:flutter_application_2/domain/models/hotel.dart';

final List<Hotel> hotels = [
  Hotel(
    name: 'Grand Hyatt',
    location: 'New York, USA',
    rating: 4.8,
    imageUrl: 'assets/images/htl0.jpg', 
    rooms: [
      Room(type: 'Standard', rate: 150.0, isAvailable: true),
      Room(type: 'Deluxe', rate: 250.0, isAvailable: false),
      Room(type: 'Suite', rate: 400.0, isAvailable: true),
    ],
  ),
  Hotel(
    name: 'Ritz-Carlton',
    location: 'Dubai, UAE',
    rating: 4.9,
    imageUrl: 'assets/images/htl1.jpg', 
    rooms: [
      Room(type: 'Classic', rate: 300.0, isAvailable: true),
      Room(type: 'Executive', rate: 450.0, isAvailable: true),
      Room(type: 'Presidential', rate: 800.0, isAvailable: false),
    ],
    
  ),
 Hotel(
    name: 'Weston Hotel',
    location: 'Nairobi, Kenya',
    rating: 4.8,
    imageUrl: 'assets/images/htl2.jpg', 
    rooms: [
      Room(type: 'Standard', rate: 450.0, isAvailable: true),
      Room(type: 'Deluxe', rate: 650.0, isAvailable: false),
      Room(type: 'Suite', rate: 400.0, isAvailable: true),
    ],
  ),
 Hotel(
    name: 'Sarrova Woodlands',
    location: 'New York, USA',
    rating: 4.8,
    imageUrl: 'assets/images/htl3.jpg', 
    rooms: [
      Room(type: 'Standard', rate: 150.0, isAvailable: true),
      Room(type: 'Deluxe', rate: 690.0, isAvailable: false),
      Room(type: 'Suite', rate: 700.0, isAvailable: true),
    ],
  ),
];
