import 'package:flutter/material.dart'; // Flutter material library
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:intl/intl.dart'; // Internationalization utilities
import 'package:flutter_application_2/payment/payment_service.dart'; // Custom payment service
import 'dart:async'; // Asynchronous operations

// BookingScreen class, StatefulWidget because it manages state
class BookingScreen extends StatefulWidget {
  final String hotelId; // ID of the hotel
  final String roomId; // ID of the room
  final double roomPrice; // Price per room

  const BookingScreen({ // Constructor requiring hotelId, roomId, and roomPrice
    Key? key,
    required this.hotelId,
    required this.roomId,
    required this.roomPrice,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState(); // Create state for BookingScreen
}

// State class for BookingScreen
class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkInDate; // Selected check-in date
  DateTime? _checkOutDate; // Selected check-out date
  double _totalPayment = 0.0; // Total payment amount
  final _paymentService = PaymentService(); // Instance of PaymentService for payment operations
  final TextEditingController _phoneNumberController = TextEditingController(); // Controller for phone number text field
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold widget defines basic material design visual layout structure
      appBar: AppBar( // AppBar widget for top app bar
        title: Text('Booking Screen'), // Title text
        backgroundColor: Colors.purple, // Custom background color
      ),
      body: SingleChildScrollView( // SingleChildScrollView to allow scrolling when keyboard is open
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the form
          child: Form( // Form widget for input validation and submission
            key: _formKey, // GlobalKey for form validation
            child: Column( // Column widget to arrange children vertically
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
              children: [
                TextFormField( // TextFormField for phone number input
                  controller: _phoneNumberController, // Controller to manage input
                  keyboardType: TextInputType.phone, // Keyboard type for phone numbers
                  decoration: InputDecoration( // Decoration for text field
                    labelText: 'Phone Number', // Label text for text field
                    border: OutlineInputBorder(), // Border around text field
                    prefixIcon: Icon(Icons.phone, color: Colors.purple), // Prefix icon for phone icon
                  ),
                  validator: _validatePhoneNumber, // Validator function for phone number
                ),
                const SizedBox(height: 16.0), // SizedBox for spacing
                Row( // Row widget to arrange check-in and check-out date fields side by side
                  children: [
                    Expanded( // Expanded widget to take remaining space in row
                      child: TextFormField( // TextFormField for check-in date
                        readOnly: true, // Read-only, user can't edit directly
                        onTap: () => _selectCheckInDate(context), // Open date picker on tap
                        decoration: InputDecoration( // Decoration for text field
                          labelText: 'Check-in Date', // Label text for text field
                          border: OutlineInputBorder(), // Border around text field
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.purple), // Suffix icon for calendar icon
                        ),
                        controller: _checkInDate != null // Display selected date if not null
                            ? TextEditingController( // Use a controller to display formatted date
                                text: DateFormat('yyyy-MM-dd').format(_checkInDate!),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16.0), // SizedBox for spacing between fields
                    Expanded( // Expanded widget for check-out date field
                      child: TextFormField( // TextFormField for check-out date
                        readOnly: true, // Read-only, user can't edit directly
                        onTap: () => _selectCheckOutDate(context), // Open date picker on tap
                        decoration: InputDecoration( // Decoration for text field
                          labelText: 'Check-out Date', // Label text for text field
                          border: OutlineInputBorder(), // Border around text field
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.purple), // Suffix icon for calendar icon
                        ),
                        controller: _checkOutDate != null // Display selected date if not null
                            ? TextEditingController( // Use a controller to display formatted date
                                text: DateFormat('yyyy-MM-dd').format(_checkOutDate!),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0), // SizedBox for spacing
                Text( // Text widget to display total payment amount
                  'Total Payment: Ksh${_totalPayment.toStringAsFixed(2)}', // Formatted total payment amount
                  style: TextStyle( // Text style for payment amount
                    fontSize: 18.0, // Font size
                    fontWeight: FontWeight.bold, // Bold font weight
                    color: Colors.purple, // Purple text color
                  ),
                ),
                const SizedBox(height: 16.0), // SizedBox for spacing
                SizedBox( // SizedBox with width set to full width available
                  width: double.infinity,
                  child: ElevatedButton( // ElevatedButton for booking action
                    onPressed: _confirmBooking, // Callback function when button is pressed
                    style: ElevatedButton.styleFrom( // Style configuration for button
                      backgroundColor: Colors.purple, // Background color of button
                      padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding inside button
                    ),
                    child: Text( // Text widget for button label
                      'Book', // Button label text
                      style: TextStyle(color: Colors.white), // Text style for button label
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to select check-in date using date picker
  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime maxCheckInDate = DateTime.now().add(const Duration(days: 90)); // Maximum allowable check-in date
    final DateTime? picked = await showDatePicker( // Show date picker dialog
      context: context, // Context of the current screen
      initialDate: DateTime.now(), // Initial date selected (today)
      firstDate: DateTime.now(), // Earliest selectable date (today)
      lastDate: maxCheckInDate, // Latest selectable date (90 days from now)
    );
    if (picked != null && picked != _checkInDate) { // If a date is selected and it's different from current check-in date
      setState(() { // Update state with new selected date
        _checkInDate = picked; // Update selected check-in date
        _calculateTotalPayment(); // Recalculate total payment based on new dates
      });
    }
  }

  // Function to select check-out date using date picker
  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime maxCheckOutDate = DateTime.now().add(const Duration(days: 30)); // Maximum allowable check-out date
    final DateTime? picked = await showDatePicker( // Show date picker dialog
      context: context, // Context of the current screen
      initialDate: _checkInDate != null ? _checkInDate!.add(const Duration(days: 1)) : DateTime.now().add(const Duration(days: 1)), // Initial date selected (next day after check-in or tomorrow)
      firstDate: _checkInDate != null ? _checkInDate!.add(const Duration(days: 1)) : DateTime.now().add(const Duration(days: 1)), // Earliest selectable date (next day after check-in or tomorrow)
      lastDate: maxCheckOutDate, // Latest selectable date (30 days from now)
    );
    if (picked != null && picked != _checkOutDate) { // If a date is selected and it's different from current check-out date
      setState(() { // Update state with new selected date
        _checkOutDate = picked; // Update selected check-out date
        _calculateTotalPayment(); // Recalculate total payment based on new dates
      });
    }
  }

  // Function to calculate total payment based on selected dates
  void _calculateTotalPayment() {
    if (_checkInDate != null && _checkOutDate != null) { // If both check-in and check-out dates are selected
      final int days = _checkOutDate!.difference(_checkInDate!).inDays; // Calculate number of days between check-in and check-out
      _totalPayment = days * widget.roomPrice; // Calculate total payment based on number of days and room price
    }
  }

  // Function to validate phone number format
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) { // If phone number is empty
      return 'Phone number cannot be empty'; // Return error message
    }
    if (!RegExp(r'^(07|01)\d{8}$').hasMatch(value)) { // If phone number format is invalid
      return 'Please enter a valid phone number'; // Return error message
    }
    return null; // Return null if phone number is valid
  }

  // Function to confirm booking and initiate payment process
  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) { // Validate form fields
      return;
    }

    final user = FirebaseAuth.instance.currentUser; // Get current logged-in user

    if (user == null) { // If user is not logged in
      ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
        const SnackBar(content: Text('You need to be logged in to book a room.')), // Inform user to log in
      );
      return; // Exit function
    }

    final phoneNumber = _phoneNumberController.text.trim(); // Extract and trim phone number from text field

    // Show the alert dialog
    showDialog( // Show dialog box for payment alert
      context: context, // Current context
      builder: (BuildContext context) {
        // Start the payment process as soon as the dialog is shown
        _startPaymentProcess(phoneNumber, user.uid); // Initiate payment process

        return AlertDialog( // AlertDialog widget for payment alert
          title: Text('Payment Alert'), // Title of the alert
          content: Text('A payment prompt will be sent to your phone by Mpesa. Please enter your pin to confirm your booking.'), // Alert content text
          actions: [
            TextButton( // TextButton for 'OK' action
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('OK'), // Button label
            ),
          ],
        );
      },
    );
  }

// Function to start the payment process
void _startPaymentProcess(String phoneNumber, String userId) async {
  try {
    // Proceed to payment
    final paymentResponse = await _paymentService.initiatePayment(phoneNumber, _totalPayment); // Call payment service to initiate payment
    if (paymentResponse['ResponseCode'] == '0') { // If payment initiated successfully
      // Payment initiated successfully
      ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
        const SnackBar(content: Text('Payment initiated successfully!')), // Inform user of successful payment initiation
      );

      // Proceed to book the room regardless of payment status
      await _bookRoom(userId, false); // Pass payment status as false initially

      // Poll for payment confirmation
      await _pollForPaymentConfirmation(phoneNumber, userId); // Poll for payment confirmation asynchronously
    } else {
      ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
        SnackBar(content: Text('Payment initiation failed: ${paymentResponse['errorMessage']}')), // Display error message from payment initiation
      );

      // Proceed to book the room regardless of payment status
      await _bookRoom(userId, false); // Pass payment status as false
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
      SnackBar(content: Text('Error: $error')), // Display generic error message
    );

    // Proceed to book the room regardless of payment status
    await _bookRoom(userId, false); // Pass payment status as false
  }
}

// Function to poll for payment confirmation
Future<void> _pollForPaymentConfirmation(String phoneNumber, String userId) async {
  bool paymentConfirmed = false; // Flag to track if payment is confirmed
  int attempts = 0; // Counter for attempts to check payment status
  const maxAttempts = 3; // Maximum number of attempts
  const pollInterval = Duration(seconds: 5); // Interval between each attempt

  while (!paymentConfirmed && attempts < maxAttempts) { // While payment is not confirmed and within maximum attempts
    try {
      final paymentStatus = await _paymentService.checkPaymentStatus(phoneNumber); // Check payment status
      if (paymentStatus == 'paid') { // If payment is confirmed
        // Payment confirmed
        paymentConfirmed = true; // Update flag
        ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
          const SnackBar(content: Text('Payment confirmed!')), // Inform user of payment confirmation
        );

        // Update booking payment status
        await _updateBookingPaymentStatus(userId, true); // Pass payment status as true
        return; // Exit function after updating booking payment status
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
        SnackBar(content: Text('Error while checking payment status: $error')), // Display error while checking payment status
      );
    }

    // Increment attempts
    attempts++;

    // Wait before polling again
    await Future.delayed(pollInterval); // Delay before next attempt
  }

  if (!paymentConfirmed) { // If payment is not confirmed after attempts
    ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
      const SnackBar(content: Text('Payment confirmation failed. Please contact support.')), // Inform user of payment confirmation failure
    );

    // Update booking payment status to false
    await _updateBookingPaymentStatus(userId, false); // Pass payment status as false
  }
}

// Function to book the room
Future<void> _bookRoom(String userId, bool paymentStatus) async {
  try {
    // Add booking details to Firestore collection
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': userId, // User ID
      'hotelId': widget.hotelId, // Hotel ID
      'roomId': widget.roomId, // Room ID
      'checkInDate': _checkInDate != null ? Timestamp.fromDate(_checkInDate!) : null, // Check-in date (if selected)
      'checkOutDate': _checkOutDate != null ? Timestamp.fromDate(_checkOutDate!) : null, // Check-out date (if selected)
      'phoneNumber': _phoneNumberController.text.trim(), // Phone number
      'totalPayment': _totalPayment, // Total payment amount
      'timestamp': FieldValue.serverTimestamp(), // Server timestamp
      'paymentStatus': paymentStatus, // Payment status (true if confirmed, false otherwise)
    });

    // Update room availability status
    await FirebaseFirestore.instance
      .collection('hotels')
      .doc(widget.hotelId)
      .collection('rooms')
      .doc(widget.roomId)
      .update({
        'isAvailable': false, // Update room availability status
      });

    ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
      const SnackBar(content: Text('Room booked successfully!')), // Inform user of successful room booking
    );

    Navigator.pop(context); // Close the booking screen
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
      SnackBar(content: Text('Error booking room: $error')), // Display error message while booking room
    );
  }
}

// Function to update booking payment status
Future<void> _updateBookingPaymentStatus(String userId, bool paymentStatus) async {
  try {
    // Update the payment status of the booking in Firestore
    await FirebaseFirestore.instance.collection('bookings')
      .where('userId', isEqualTo: userId)
      .where('hotelId', isEqualTo: widget.hotelId)
      .where('roomId', isEqualTo: widget.roomId)
      .limit(1)
      .get()
      .then((querySnapshot) {
        querySnapshot.docs.first.reference.update({
          'paymentStatus': paymentStatus, // Update payment status
        });
      });
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar( // Show snackbar message
      SnackBar(content: Text('Error updating payment status: $error')), // Display error message while updating payment status
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