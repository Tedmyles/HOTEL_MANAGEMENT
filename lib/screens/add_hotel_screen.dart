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
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final imageUrlController = TextEditingController();
  double rating = 0.0;

  @override
  void dispose() {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Slider(
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: 'Rating: $rating',
                onChanged: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                controller: imageUrlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Generate a new document ID for the hotel
                    final hotelCollection = FirebaseFirestore.instance.collection('hotels');
                    final newHotelDoc = hotelCollection.doc();

                    Hotel hotel = Hotel(
                      id: newHotelDoc.id,
                      name: nameController.text,
                      location: locationController.text,
                      imageUrl: imageUrlController.text,
                      rating: rating,
                    );

                    // Add the new hotel to Firestore
                    await newHotelDoc.set(hotel.toJson());

                    // Notify provider
                    Provider.of<HotelProvider>(context, listen: false).addHotel(hotel);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}