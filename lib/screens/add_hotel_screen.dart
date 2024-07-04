import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/domain/models/hotel.dart';
import 'package:flutter_application_2/providers/hotel_provider.dart';
import 'package:provider/provider.dart';

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({Key? key}) : super(key: key);

  @override
  _AddHotelScreenState createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  // GlobalKey to manage the form state
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final hotelIdController = TextEditingController();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final imageUrlController = TextEditingController();
  double rating = 0.0; // Default rating value

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    hotelIdController.dispose();
    nameController.dispose();
    locationController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Associate the GlobalKey with the Form widget
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text field for Hotel ID
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Hotel ID',
                    border: OutlineInputBorder(),
                  ),
                  controller: hotelIdController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a hotel ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Text field for Hotel Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Text field for Hotel Location
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  controller: locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Slider for Hotel Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rating: $rating'),
                    Slider(
                      value: rating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 5,
                      onChanged: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Text field for Image URL
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  controller: imageUrlController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Submit button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If form is valid, proceed to save the hotel data
                      final hotelId = hotelIdController.text.trim();
                      final hotelDoc = FirebaseFirestore.instance.collection('hotels').doc(hotelId);

                      // Create a Hotel object from input data
                      Hotel hotel = Hotel(
                        id: hotelId,
                        name: nameController.text.trim(),
                        location: locationController.text.trim(),
                        imageUrl: imageUrlController.text.trim(),
                        rating: rating,
                      );

                      // Save the hotel data to Firestore
                      await hotelDoc.set(hotel.toJson());

                      // Update local state using Provider 
                      Provider.of<HotelProvider>(context, listen: false).addHotel(hotel);

                      // Navigate back to previous screen
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
