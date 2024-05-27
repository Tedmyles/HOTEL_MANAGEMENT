// import 'package:flutter_application_2/domain/models/room.dart';

// class Hotel {
//   final int id;
//   final String name;
//   final String location;
//   final double rating;
//   final String imageUrl;
//   final List<Room> rooms;

//   Hotel({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.imageUrl,
//     required this.rooms,
//   });

//   //serialize data to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'location': location,
//       'rating': rating,
//       'imageUrl': imageUrl,
//       'rooms': rooms.map((room) => room.toJson()).toList(),
//     };
//   }

//   //deserialize JSON to data
//   factory Hotel.fromJson(Map<String, dynamic> json) {
//     return Hotel(
//       id: json['id'],
//       name: json['name'],
//       location: json['location'],
//       rating: json['rating'],
//       imageUrl: json['imageUrl'],
//       rooms: List<Room>.from(json['rooms'].map((room) => Room.fromJson(room))),
//     );
//   }
// }

class Hotel {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final List<Room> rooms;

  Hotel({
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.rooms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

class Room {
  final String type;
   final double price;
  final double rate;
  final bool isAvailable;
    final String imageUrl;

  Room({
    required this.type,
    required this.price,
    required this.rate,
    required this.isAvailable,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'rate': rate,
      'isAvailable': isAvailable,
       'imageUrl': imageUrl,
    };
  }
}
