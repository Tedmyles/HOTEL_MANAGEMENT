import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class ViewBookingsPage extends StatefulWidget {
  const ViewBookingsPage({Key? key}) : super(key: key);

  @override
  _ViewBookingsPageState createState() => _ViewBookingsPageState();
}

class _ViewBookingsPageState extends State<ViewBookingsPage> {
  late Stream<QuerySnapshot> _bookingsStream;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID
  DocumentSnapshot? _selectedBooking; // Variable to store the selected booking

  @override
  void initState() {
    super.initState();
    if (_userId != null) {
      _bookingsStream = FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: _userId)
          .snapshots(); // Fetch bookings for the current user
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMM d, yyyy, hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Bookings'),
      ),
      body: _userId == null
          ? Center(child: Text('User not logged in.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _bookingsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No bookings available.'));
                }

                // Display the list of bookings and details of the selected booking
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var booking = snapshot.data!.docs[index];
                          var phoneNumber = booking['phoneNumber'];
                          var userId = booking['userId'];
                          var hotelId = booking['hotelId'];

                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              title: Text('Phone Number: $phoneNumber'),
                              subtitle: Text('Hotel ID: $hotelId'),
                              onTap: () {
                                setState(() {
                                  _selectedBooking = booking; // Set the selected booking
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (_selectedBooking != null) _buildBookingDetails(_selectedBooking!),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildBookingDetails(DocumentSnapshot booking) {
    var phoneNumber = booking['phoneNumber'];
    var userId = booking['userId'];
    var hotelId = booking['hotelId'];
    var checkInDate = booking['checkInDate'] as Timestamp;
    var checkOutDate = booking['checkOutDate'] as Timestamp;
    var paymentStatus = booking['paymentStatus'] as bool;
    var roomId = booking['roomId'];
    var timestamp = booking['timestamp'] as Timestamp;
    var totalPayment = booking['totalPayment'] as num;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Phone Number', phoneNumber),
          _buildDetailRow('User ID', userId),
          _buildDetailRow('Hotel', hotelId),
          _buildDetailRow('Room ID', roomId),
          _buildDetailRow('Check-In Date', _formatTimestamp(checkInDate)),
          _buildDetailRow('Check-Out Date', _formatTimestamp(checkOutDate)),
          _buildDetailRow('Total Payment', 'Ksh $totalPayment'),
          _buildDetailRow('Payment Status', paymentStatus ? 'Paid' : 'Pending'),
          _buildDetailRow('Timestamp', _formatTimestamp(timestamp)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
