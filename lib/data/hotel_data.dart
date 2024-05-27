import 'package:flutter_application_2/domain/models/hotel.dart';

// Sample data for hotels
List<Hotel> hotels = [
  Hotel(
    name: 'Hotel California',
    location: 'Los Angeles',
    rating: 4.5,
    imageUrl: 'assets/images/htl0.jpg',
    rooms: [
      Room(
        type: 'Standard',
        rate: 150.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl1.jpg',
        price: 100.0,
      ),
      Room(
        type: 'Deluxe',
        rate: 250.0,
        isAvailable: false,
        imageUrl: 'assets/images/htl2.jpg',
        price: 200.0,
      ),
      Room(
        type: 'Suite',
        rate: 400.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl3.jpg',
        price: 350.0,
      ),
    ],
  ),
  Hotel(
    name: 'The Grand Budapest Hotel',
    location: 'Budapest',
    rating: 4.8,
    imageUrl: 'assets/images/htl0.jpg',
    rooms: [
      Room(
        type: 'Classic',
        rate: 300.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl0.jpg',
        price: 250.0,
      ),
      Room(
        type: 'Executive',
        rate: 450.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl0.jpg',
        price: 400.0,
      ),
      Room(
        type: 'Presidential',
        rate: 800.0,
        isAvailable: false,
        imageUrl: 'assets/images/htl0.jpg',
        price: 750.0,
      ),
    ],
  ),
  Hotel(
    name: 'The Ritz-Carlton',
    location: 'New York City',
    rating: 4.7,
    imageUrl: 'assets/images/htl0.jpg',
    rooms: [
      Room(
        type: 'Standard',
        rate: 450.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl0.jpg',
        price: 400.0,
      ),
      Room(
        type: 'Deluxe',
        rate: 650.0,
        isAvailable: false,
        imageUrl: 'https://example.com/room_deluxe.jpg',
        price: 600.0,
      ),
      Room(
        type: 'Suite',
        rate: 400.0,
        isAvailable: true,
        imageUrl: 'https://example.com/room_suite.jpg',
        price: 350.0,
      ),
    ],
  ),
  Hotel(
    name: 'Hotel Transylvania',
    location: 'Transylvania',
    rating: 4.2,
    imageUrl: 'https://example.com/hotel_transylvania.jpg',
    rooms: [
      Room(
        type: 'Standard',
        rate: 150.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl0.jpg',
        price: 100.0,
      ),
      Room(
        type: 'Deluxe',
        rate: 690.0,
        isAvailable: false,
        imageUrl: 'assets/images/htl0.jpg',
        price: 650.0,
      ),
      Room(
        type: 'Suite',
        rate: 700.0,
        isAvailable: true,
        imageUrl: 'assets/images/htl0.jpg',
        price: 650.0,
      ),
    ],
  ),
];
