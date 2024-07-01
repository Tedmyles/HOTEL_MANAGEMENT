import 'package:flutter/material.dart';
import 'package:flutter_application_2/presentation/authentication/screens/admin_profile.dart';
import 'package:flutter_application_2/presentation/authentication/screens/users_list_page.dart';
import '../../screens/add_hotel_screen.dart';
import '../../screens/add_room.dart';
import '../../screens/view_hotel.dart';
import '../../screens/admin_view_bookings.dart'; 

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Color.fromARGB(255, 40, 177, 127),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildAdminOptions(),
          AdminProfilePage(),
          UsersListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.green[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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

  Widget buildAdminOptions() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: Icon(Icons.add_business),
          title: Text('Add Hotel'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHotelScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Room'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminAddRoomScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.hotel),
          title: Text('View Hotels'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewHotelsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('View Users'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListPage(),
              ),
            );
          },
        ),
        ListTile( // New list tile for View Bookings
          leading: Icon(Icons.book), // Icon for View Bookings
          title: Text('View Bookings'), // Title text for View Bookings
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewBookingsPage(), // Navigate to ViewBookingsPage
              ),
            );
          },
        ),
      ],
    );
  }
}
