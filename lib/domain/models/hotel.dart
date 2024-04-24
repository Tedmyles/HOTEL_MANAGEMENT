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
}

class Room {
  final String type;
  final double rate;
  final bool isAvailable;

  Room({
    required this.type,
    required this.rate,
    required this.isAvailable,
  });
}
