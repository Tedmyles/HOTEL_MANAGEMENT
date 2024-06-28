import 'package:flutter/material.dart'; // Import Flutter material library
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:flutter_application_2/domain/models/hotel.dart'; // Import Hotel model
import 'package:flutter_application_2/screens/hotel_details_screen.dart'; // Import hotel details screen
import 'package:flutter_application_2/presentation/authentication/screens/profile.dart'; // Import profile screen

// HotelListScreen class, extends StatefulWidget because it manages state
class HotelListScreen extends StatefulWidget {
  const HotelListScreen({Key? key}) : super(key: key);

  @override
  _HotelListScreenState createState() =>
      _HotelListScreenState(); // Create state for HotelListScreen
}

// State class for HotelListScreen
class _HotelListScreenState extends State<HotelListScreen> {
  int _currentIndex = 0; // Index to track current tab in bottom navigation
  late Future<List<Hotel>> _hotelsFuture; // Future to fetch list of hotels
  late Future<List<Destination>>
      _destinationsFuture; // Future to fetch list of destinations

  @override
  void initState() {
    super.initState();
    _hotelsFuture = fetchHotels(); // Initialize hotel fetching
    _destinationsFuture =
        fetchDestinations(); // Initialize destination fetching
  }

  // Asynchronous method to fetch hotels from Firestore
  Future<List<Hotel>> fetchHotels() async {
    QuerySnapshot hotelsSnapshot =
        await FirebaseFirestore.instance.collection('hotels').get();
    return hotelsSnapshot.docs.map((doc) {
      return Hotel.fromMap(doc.data() as Map<String, dynamic>,
          doc.id); // Convert Firestore document to Hotel object
    }).toList();
  }

  // Asynchronous method to fetch destinations from Firestore
  Future<List<Destination>> fetchDestinations() async {
    QuerySnapshot destinationsSnapshot =
        await FirebaseFirestore.instance.collection('destinations').get();
    return destinationsSnapshot.docs.map((doc) {
      return Destination.fromMap(doc.data() as Map<String, dynamic>,
          doc.id); // Convert Firestore document to Destination object
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget defines basic material design visual layout structure
      body: IndexedStack(
        // IndexedStack widget to manage multiple children with an index
        index: _currentIndex, // Index of currently displayed child
        children: [
          Column(
            // First child: Column with hotels and destinations lists
            children: [
              Container(
                color: Colors.purple, // Purple color for top navigation bar
                padding: const EdgeInsets.only(
                    top: 40, bottom: 10), // Padding for top and bottom
                child: const Center(
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text(
                      'Hotels',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // Expanded widget to occupy remaining space
                child: ListView(
                  children: [
                    buildHotelList(), // Method to build hotel list
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text(
                            'Destinations',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildDestinationList(), // Method to build destination list
                  ],
                ),
              ),
            ],
          ),
          const ProfilePage(), // Second child: Profile page/tab
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar widget for navigation tabs
        currentIndex: _currentIndex, // Current index for selected tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel), // Hotel icon
            label: 'Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Callback when tab is tapped
          setState(() {
            _currentIndex = index; // Update current index
          });
        },
      ),
    );
  }

  // Method to build hotel list using FutureBuilder
  Widget buildHotelList() {
    return FutureBuilder<List<Hotel>>(
      future: _hotelsFuture, // Future containing list of hotels
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          // Error state
          return const Center(
              child: Text('Error loading hotels')); // Show error message
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // No data state
          return const Center(
              child: Text('No hotels found')); // Show no hotels message
        } else {
          // Data available state
          final hotels = snapshot.data!; // Extract hotel list from snapshot
          return SizedBox(
            // SizedBox to constrain size of hotel list
            height: 300, // Height of each hotel card
            child: ListView.builder(
              // ListView.builder to build list of hotel cards
              scrollDirection:
                  Axis.horizontal, // Horizontal scrolling for hotel cards
              itemCount: hotels.length, // Number of hotels
              itemBuilder: (context, index) {
                final hotel = hotels[index]; // Current hotel in list
                return GestureDetector(
                  // GestureDetector for tapping on hotel card
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailsScreen(
                            hotel: hotel), // Navigate to hotel details screen
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Width of hotel card
                    margin:
                        const EdgeInsets.all(8.0), // Margin around hotel card
                    child: Card(
                      // Card widget for hotel information
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, // Stretch content horizontally
                        children: [
                          Expanded(
                            // Expanded widget for hotel image
                            child: Image.network(
                              hotel.imageUrl, // Hotel image URL
                              fit: BoxFit.cover, // Cover image fit
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Padding around hotel details
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align content to start horizontally
                              children: [
                                Text(
                                  hotel.name, // Hotel name
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold font weight
                                    fontSize: 16.0, // Font size
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        4.0), // Fixed height between elements
                                Text(
                                  hotel.location, // Hotel location
                                  style: const TextStyle(
                                    fontSize: 14.0, // Font size
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        8.0), // Fixed height between elements
                                StarRating(
                                    rating: hotel
                                        .rating), // StarRating widget for hotel rating
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  // Method to build destination list using FutureBuilder
  Widget buildDestinationList() {
    return FutureBuilder<List<Destination>>(
      future: _destinationsFuture, // Future containing list of destinations
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          // Error state
          return const Center(
              child: Text('Error loading destinations')); // Show error message
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // No data state
          return const Center(
              child: Text(
                  'No destinations found')); // Show no destinations message
        } else {
          // Data available state
          final destinations =
              snapshot.data!; // Extract destination list from snapshot
          return SizedBox(
            // SizedBox to constrain size of destination list
            height: 200, // Height of each destination card
            child: ListView.builder(
              // ListView.builder to build list of destination cards
              scrollDirection:
                  Axis.horizontal, // Horizontal scrolling for destination cards
              itemCount: destinations.length, // Number of destinations
              itemBuilder: (context, index) {
                final destination =
                    destinations[index]; // Current destination in list
                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.6, // Width of destination card
                  margin: const EdgeInsets.all(
                      8.0), // Margin around destination card
                  child: Card(
                    // Card widget for destination information
                    child: Stack(
                      // Stack widget to overlay destination name on image
                      children: [
                        Positioned.fill(
                          // Positioned.fill to fill parent widget
                          child: ClipRRect(
                            // ClipRRect widget to clip rounded corners
                            borderRadius: BorderRadius.circular(
                                8.0), // Border radius for rounded corners
                            child: Image.network(
                              destination.imageUrl, // Destination image URL
                              fit: BoxFit.cover, // Cover image fit
                            ),
                          ),
                        ),
                        Positioned(
                          // Positioned widget to position destination name
                          bottom: 0, // Align bottom of destination card
                          left: 0, // Align left of destination card
                          right: 0, // Align right of destination card
                          child: Container(
                            // Container widget for background of destination name
                            color:
                                Colors.black54, // Background color with opacity
                            padding: const EdgeInsets.all(
                                8.0), // Padding around destination name
                            child: Text(
                              destination.name, // Destination name
                              style: const TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 16.0, // Font size
                                fontWeight: FontWeight.bold, // Bold font weight
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

// Destination class representing a destination with id, imageUrl, and name
class Destination {
  final String id; // Destination id
  final String imageUrl; // Destination image URL
  final String name; // Destination name

  // Constructor for Destination class
  Destination({required this.id, required this.imageUrl, required this.name});

  // Factory method to create Destination object from Firestore data
  factory Destination.fromMap(Map<String, dynamic> data, String id) {
    return Destination(
      id: id, // Destination id
      imageUrl: data['imageUrl'] as String, // Destination image URL
      name: data['name'] as String, // Destination name
    );
  }
}

// StarRating widget to display star ratings
class StarRating extends StatelessWidget {
  final double rating; // Rating value

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // Row widget to display stars horizontally
      children: List.generate(5, (index) {
        return Icon(
          index < rating
              ? Icons.star
              : Icons.star_border, // Full star or border star based on rating
          color: Colors.amber, // Star color
        );
      }),
    );
  }
}

void main() {
  runApp(MaterialApp(
    // MaterialApp widget for Flutter application
    home: HotelListScreen(), // Set HotelListScreen as home screen
  ));
}
