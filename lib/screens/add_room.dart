import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddRoomScreen extends StatefulWidget {
  @override
  _AdminAddRoomScreenState createState() => _AdminAddRoomScreenState();
}

class _AdminAddRoomScreenState extends State<AdminAddRoomScreen> {
  final TextEditingController _hotelIdController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController(); // Changed
  final TextEditingController _roomPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addRoom() async {
    if (_formKey.currentState!.validate()) {
      final hotelId = _hotelIdController.text.trim();
      final roomType = _roomTypeController.text.trim(); // Changed
      final roomPrice = double.parse(_roomPriceController.text.trim());
      final imageUrl = _imageUrlController.text.trim();

      await FirebaseFirestore.instance.collection('hotels').doc(hotelId).collection('rooms').add({
        'type': roomType, // Changed
        'price': roomPrice,
        'isAvailable': true,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room added successfully!')));
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              TextFormField(
                controller: _roomTypeController, // Changed
                decoration: InputDecoration(labelText: 'Room Type'), // Changed
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roomPriceController,
                decoration: InputDecoration(labelText: 'Room Price'),
                keyboardType: TextInputType.number,
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
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
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
