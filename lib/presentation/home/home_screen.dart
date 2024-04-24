import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/hotel_data.dart'; // Import hotel data
import 'package:flutter_application_2/domain/models/hotel.dart';
import 'package:flutter_application_2/screens/room_details_screen.dart'; // Import RoomDetailsScreen if it's in a separate file
import 'package:flutter_application_2/presentation/authentication/screens/profile.dart'; // Import the Profile screen

class HotelListScreen extends StatefulWidget {
  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Hotel List'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildHotelList(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
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
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget buildHotelList() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: hotels.length, // Assuming hotels list is defined before this point
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return GestureDetector(
          onTap: () {
            // Navigate to room details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomDetailsScreen(room: hotel.rooms[0]), // Assuming there's at least one room
              ),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    hotel.imageUrl, // Access the imageUrl property
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        hotel.location,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            hotel.rating.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
