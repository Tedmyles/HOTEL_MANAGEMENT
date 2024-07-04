class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String imageUrl;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }

  static Hotel fromMap(Map<String, dynamic> data, String documentId) {
    return Hotel(
      id: documentId,
      name: data['name'],
      location: data['location'],
      rating: (data['rating'] as num).toDouble(),
      imageUrl: data['imageUrl'],
    );
  }
}
