import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_2/payment/payment_service.dart';
import 'dart:async';

class BookingScreen extends StatefulWidget {
  final String hotelId;
  final String roomId;
  final double roomPrice;

  const BookingScreen({
    Key? key,
    required this.hotelId,
    required this.roomId,
    required this.roomPrice,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  double _totalPayment = 0.0;
  final _paymentService = PaymentService();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Booking Screen'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: _validatePhoneNumber,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectCheckInDate(context),
                      decoration: InputDecoration(
                        labelText: 'Check-in Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: _checkInDate != null
                          ? TextEditingController(
                              text: DateFormat('yyyy-MM-dd').format(_checkInDate!),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectCheckOutDate(context),
                      decoration: InputDecoration(
                        labelText: 'Check-out Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: _checkOutDate != null
                          ? TextEditingController(
                              text: DateFormat('yyyy-MM-dd').format(_checkOutDate!),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Payment: ${_totalPayment.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ), // Display total payment amount
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _confirmBooking,
                child: Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime maxCheckInDate = DateTime.now().add(Duration(days: 90));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: maxCheckInDate,
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
        _calculateTotalPayment();
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime maxCheckOutDate = DateTime.now().add(Duration(days: 30));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate != null ? _checkInDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      firstDate: _checkInDate != null ? _checkInDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      lastDate: maxCheckOutDate,
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
        _calculateTotalPayment();
      });
    }
  }

  void _calculateTotalPayment() {
    if (_checkInDate != null && _checkOutDate != null) {
      final int days = _checkOutDate!.difference(_checkInDate!).inDays;
      _totalPayment = days * widget.roomPrice;
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^(07|01)\d{8}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to book a room.')),
      );
      return;
    }

    final phoneNumber = _phoneNumberController.text.trim();

    try {
      // Proceed to payment
      final paymentResponse = await _paymentService.initiatePayment(phoneNumber, _totalPayment);
      if (paymentResponse['ResponseCode'] == '0') {
        // Payment initiated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment initiated successfully!')),
        );

        // Poll for payment confirmation
        await _pollForPaymentConfirmation(phoneNumber, user.uid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: ${paymentResponse['errorMessage']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _pollForPaymentConfirmation(String phoneNumber, String userId) async {
    bool paymentConfirmed = false;
    int attempts = 0;
    const maxAttempts = 3;
    const pollInterval = Duration(seconds: 5);

    while (!paymentConfirmed && attempts < maxAttempts) {
      try {
        final paymentStatus = await _paymentService.checkPaymentStatus(phoneNumber);
        if (paymentStatus == 'paid') {
          // Payment confirmed
          paymentConfirmed = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment confirmed!')),
          );

          // Proceed to book the room
          await _bookRoom(userId);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error while checking payment status: $error')),
        );
      }

      // Increment attempts
      attempts++;

      // Wait before polling again
      await Future.delayed(pollInterval);
    }

    if (!paymentConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment confirmation failed. Please contact support.')),
      );
    }
  }
Future<void> _bookRoom(String userId) async {
  try {
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': userId,
      'hotelId': widget.hotelId,
      'roomId': widget.roomId,
      'checkInDate': _checkInDate != null ? Timestamp.fromDate(_checkInDate!) : null,
      'checkOutDate': _checkOutDate != null ? Timestamp.fromDate(_checkOutDate!) : null,
      'phoneNumber': _phoneNumberController.text.trim(),
      'totalPayment': _totalPayment,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room booked successfully!')),
    );

    Navigator.pop(context); // Close the booking screen
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error booking room: $error')),
    );
  }
}
}
  


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class BookingScreen extends StatefulWidget {
//   final String hotelId;
//   final String roomId;
//   final double roomPrice;

//   const BookingScreen({
//     Key? key,
//     required this.hotelId,
//     required this.roomId,
//     required this.roomPrice,
//   }) : super(key: key);

//   @override
//   _BookingScreenState createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   DateTime? _checkInDate;
//   DateTime? _checkOutDate;
//   double _totalPayment = 0.0;

//   Future<void> _selectCheckInDate(BuildContext context) async {
//     final DateTime maxCheckInDate = DateTime.now().add(Duration(days: 90));
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: maxCheckInDate,
//     );
//     if (picked != null && picked != _checkInDate) {
//       setState(() {
//         _checkInDate = picked;
//         _calculateTotalPayment();
//       });
//     }
//   }

//   Future<void> _selectCheckOutDate(BuildContext context) async {
//     final DateTime maxCheckOutDate = DateTime.now().add(Duration(days: 30));
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _checkInDate != null ? _checkInDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
//       firstDate: _checkInDate != null ? _checkInDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
//       lastDate: maxCheckOutDate,
//     );
//     if (picked != null && picked != _checkOutDate) {
//       setState(() {
//         _checkOutDate = picked;
//         _calculateTotalPayment();
//       });
//     }
//   }

//   void _calculateTotalPayment() {
//     if (_checkInDate != null && _checkOutDate != null) {
//       final int days = _checkOutDate!.difference(_checkInDate!).inDays;
//       _totalPayment = days * widget.roomPrice;
//     }
//   }

//   Future<void> _confirmBooking() async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You need to be logged in to book a room.')),
//       );
//       return;
//     }

//     final roomRef = FirebaseFirestore.instance
//         .collection('hotels')
//         .doc(widget.hotelId)
//         .collection('rooms')
//         .doc(widget.roomId);

//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       final roomSnapshot = await transaction.get(roomRef);

//       if (!roomSnapshot.exists || roomSnapshot['isAvailable'] == false) {
//         throw Exception('Room is no longer available.');
//       }

//       transaction.update(roomRef, {
//         'isAvailable': false,
//         'bookedBy': user.uid,
//         'checkInDate': _checkInDate,
//         'checkOutDate': _checkOutDate,
//         'totalPayment': _totalPayment,
//       });
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Room booked successfully!')),
//     );
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Room'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Check-in Date'),
//               subtitle: Text(_checkInDate == null ? 'Select check-in date' : DateFormat.yMMMd().format(_checkInDate!)),
//               onTap: () => _selectCheckInDate(context),
//             ),
//             ListTile(
//               title: const Text('Check-out Date'),
//               subtitle: Text(_checkOutDate == null ? 'Select check-out date' : DateFormat.yMMMd().format(_checkOutDate!)),
//               onTap: () => _selectCheckOutDate(context),
//             ),
//             const SizedBox(height: 20.0),
//             Text(
//               'Total Payment: Ksh${_totalPayment.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: (_checkInDate != null && _checkOutDate != null)
//                   ? _confirmBooking
//                   : null,
//               child: const Text('Confirm Booking'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }