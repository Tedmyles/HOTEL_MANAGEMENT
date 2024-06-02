class Room {
  final String id;
  final String type;
  final bool isAvailable;
  final double price;
  final String imageUrl;

  Room({
    required this.id,
    required this.type,
    required this.isAvailable,
    required this.price,
    required this.imageUrl,
  });

  factory Room.fromMap(Map<String, dynamic> data, String documentId) {
    return Room(
      id: documentId,
      type: data['type'] ?? 'Unknown',  // Provide a default value for type
      isAvailable: data['isAvailable'] ?? false,  // Provide a default value for isAvailable
      price: (data['price'] as num?)?.toDouble() ?? 0.0,  // Provide a default value for price
      imageUrl: data['imageUrl'] ?? '',  // Provide a default value for imageUrl
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'isAvailable': isAvailable,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
