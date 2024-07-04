import 'package:flutter/material.dart'; // Import Flutter material design widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore database

class AdminAddRoomScreen extends StatefulWidget {
  @override
  _AdminAddRoomScreenState createState() => _AdminAddRoomScreenState();
}

class _AdminAddRoomScreenState extends State<AdminAddRoomScreen> {
  // Controllers for handling text input fields
  final TextEditingController _hotelIdController = TextEditingController(); // Controller for hotel ID input
  final TextEditingController _roomTypeController = TextEditingController(); // Controller for room type input
  final TextEditingController _roomPriceController = TextEditingController(); // Controller for room price input
  final TextEditingController _imageUrlController = TextEditingController(); // Controller for image URL input

  // Global key for managing the form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to add a room to Firestore
  void _addRoom() async {
    // Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      // Extract data from text controllers
      final hotelId = _hotelIdController.text.trim(); // Extract hotel ID
      final roomType = _roomTypeController.text.trim(); // Extract room type
      final roomPrice = double.parse(_roomPriceController.text.trim()); // Parse room price as double
      final imageUrl = _imageUrlController.text.trim(); // Extract image URL

      // Add room data to Firestore under 'rooms' collection for the specified hotel
      await FirebaseFirestore.instance.collection('hotels').doc(hotelId).collection('rooms').add({
        'type': roomType, // Room type
        'price': roomPrice, // Room price
        'isAvailable': true, // Assuming the room is available by default
        'imageUrl': imageUrl, // Image URL for the room
      });

      // Show a snack bar message upon successful addition
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room added successfully!')));
      
      // Reset the form after adding the room
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'), // Set app bar title
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associate the form with the global key
          child: Column(
            children: [
              // Text form field for hotel ID input
              TextFormField(
                controller: _hotelIdController,
                decoration: InputDecoration(labelText: 'Hotel ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hotel ID';
                  }
                  return null;
                },
              ),
              // Text form field for room type input
              TextFormField(
                controller: _roomTypeController,
                decoration: InputDecoration(labelText: 'Room Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room type';
                  }
                  return null;
                },
              ),
              // Text form field for room price input
              TextFormField(
                controller: _roomPriceController,
                decoration: InputDecoration(labelText: 'Room Price'),
                keyboardType: TextInputType.number, // Set numeric keyboard type
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Text form field for image URL input
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20), // Spacer for layout
              // Elevated button to trigger room addition process
              ElevatedButton(
                onPressed: _addRoom,
                child: Text('Add Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
