import 'package:flutter/material.dart'; // Import Flutter material library
import 'package:flutter_application_2/presentation/authentication/screens/admin_profile.dart'; // Import admin profile screen
import 'package:flutter_application_2/presentation/authentication/screens/users_list_page.dart'; // Import users list page

import '../../screens/add_hotel_screen.dart'; // Import add hotel screen from relative path
import '../../screens/add_room.dart'; // Import add room screen from relative path
import '../../screens/view_hotel.dart'; // Import view hotels screen from relative path

// AdminDashboard class, extends StatefulWidget because it manages state
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState(); // Create state for AdminDashboard
}

// State class for AdminDashboard
class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0; // Index to track current tab in bottom navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold widget defines basic material design visual layout structure
      appBar: AppBar( // AppBar widget for top app bar
        title: const Text('Admin Dashboard'), // Title text
        backgroundColor: Color.fromARGB(255, 40, 177, 127), // Custom background color
        automaticallyImplyLeading: false, // Disable back button on app bar
      ),
      body: IndexedStack( // IndexedStack widget to manage multiple children with an index
        index: _currentIndex, // Index of currently displayed child
        children: [
          buildAdminOptions(), // Method to build admin options list
          AdminProfilePage(), // Admin profile page/tab
          UsersListPage(), // Users list page/tab
        ],
      ),
      bottomNavigationBar: BottomNavigationBar( // BottomNavigationBar widget for navigation tabs
        currentIndex: _currentIndex, // Current index for selected tab
        backgroundColor: Colors.green[900], // Background color for bottom navigation bar
        selectedItemColor: Colors.white, // Selected item color
        unselectedItemColor: Colors.grey[400], // Unselected item color
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
        onTap: (index) { // Callback when tab is tapped
          setState(() {
            _currentIndex = index; // Update current index
          });
        },
      ),
    );
  }

  // Method to build admin options list using ListView
  Widget buildAdminOptions() {
    return ListView( // ListView widget to display a scrollable list of options
      padding: const EdgeInsets.all(16.0), // Padding around list items
      children: [
        ListTile( // ListTile widget for each option
          leading: Icon(Icons.add_business), // Leading icon for "Add Hotel" option
          title: Text('Add Hotel'), // Title text for "Add Hotel" option
          onTap: () { // Callback when "Add Hotel" option is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHotelScreen(), // Navigate to AddHotelScreen
              ),
            );
          },
        ),
        ListTile( // ListTile widget for "Add Room" option
          leading: Icon(Icons.add), // Leading icon for "Add Room" option
          title: Text('Add Room'), // Title text for "Add Room" option
          onTap: () { // Callback when "Add Room" option is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminAddRoomScreen(), // Navigate to AdminAddRoomScreen
              ),
            );
          },
        ),
        ListTile( // ListTile widget for "View Hotels" option
          leading: Icon(Icons.hotel), // Leading icon for "View Hotels" option
          title: Text('View Hotels'), // Title text for "View Hotels" option
          onTap: () { // Callback when "View Hotels" option is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewHotelsScreen(), // Navigate to ViewHotelsScreen
              ),
            );
          },
        ),
        ListTile( // ListTile widget for "View Users" option
          leading: Icon(Icons.person), // Leading icon for "View Users" option
          title: Text('View Users'), // Title text for "View Users" option
          onTap: () { // Callback when "View Users" option is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListPage(), // Navigate to UsersListPage
              ),
            );
          },
        ),
      ],
    );
  }
}
