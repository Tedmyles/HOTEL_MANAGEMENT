import 'package:flutter/material.dart'; // Import Flutter material design widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore database
import 'package:intl/intl.dart'; // Import for date formatting

class ViewBookingsPage extends StatefulWidget {
  const ViewBookingsPage({Key? key}) : super(key: key);

  @override
  _ViewBookingsPageState createState() => _ViewBookingsPageState();
}

class _ViewBookingsPageState extends State<ViewBookingsPage> {
  late Stream<QuerySnapshot> _bookingsStream; // Stream to hold Firestore query results

  @override
  void initState() {
    super.initState();
    // Fetching all bookings from Firestore
    _bookingsStream = FirebaseFirestore.instance.collection('bookings').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Bookings'), // App bar title
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while data is being fetched
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Show error message if there's an error with the stream
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Show message if there are no bookings available
            return Center(child: Text('No bookings available.'));
          }

          // Display the list of bookings
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              var phoneNumber = booking['phoneNumber'];
              var userId = booking['userId'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Phone Number: $phoneNumber'),
                  subtitle: Text('User ID: $userId'),
                  onTap: () {
                    // Navigate to booking details page when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(
                          booking: booking,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final DocumentSnapshot booking; // Snapshot of the booking document from Firestore

  const BookingDetailsPage({Key? key, required this.booking}) : super(key: key);

  // Format Firestore timestamp to readable date format
  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMM d, yyyy, hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    // Extract booking details from Firestore document snapshot
    var phoneNumber = booking['phoneNumber'];
    var userId = booking['userId'];
    var hotelId = booking['hotelId'];
    var checkInDate = booking['checkInDate'] as Timestamp;
    var checkOutDate = booking['checkOutDate'] as Timestamp;
    var paymentStatus = booking['paymentStatus'] as bool;
    var roomId = booking['roomId'];
    var timestamp = booking['timestamp'] as Timestamp;
    var totalPayment = booking['totalPayment'] as num;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Phone Number', phoneNumber), // Display phone number
            _buildDetailRow('User ID', userId), // Display user ID
            _buildDetailRow('Hotel ID', hotelId), // Display hotel ID
            _buildDetailRow('Room ID', roomId), // Display room ID
            _buildDetailRow('Check-In Date', _formatTimestamp(checkInDate)), // Format and display check-in date
            _buildDetailRow('Check-Out Date', _formatTimestamp(checkOutDate)), // Format and display check-out date
            _buildDetailRow('Total Payment', 'Ksh $totalPayment'), // Display total payment with currency
            _buildDetailRow('Payment Status', paymentStatus ? 'Paid' : 'Pending'), // Display payment status
            _buildDetailRow('Timestamp', _formatTimestamp(timestamp)), // Format and display timestamp
            if (!paymentStatus)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentDialog(context, phoneNumber, totalPayment), // Trigger payment status update dialog
                  icon: Icon(Icons.payment),
                  label: Text('Update Payment Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:', // Label text
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value, // Value text
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // Method to show a dialog for updating payment status
  void _showPaymentDialog(BuildContext context, String phoneNumber, num totalPayment) {
    TextEditingController _mpesaCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter MPesa Confirmation Code'), // Dialog title
          content: TextField(
            controller: _mpesaCodeController,
            decoration: InputDecoration(hintText: 'MPesa Confirmation Code'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'), // Cancel button
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'), // Confirm button
              onPressed: () async {
                String mpesaCode = _mpesaCodeController.text.trim();

                if (mpesaCode.isNotEmpty) {
                  // Update the payment status in Firestore
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(booking.id)
                      .update({
                    'paymentStatus': true,
                    'mpesaCode': mpesaCode, // Optional: Store the MPesa code if needed
                  });

                  // Add payment details to the 'payments' collection
                  await FirebaseFirestore.instance.collection('payments').add({
                    'mpesaCode': mpesaCode,
                    'phoneNumber': phoneNumber,
                    'amount': totalPayment,
                    'timestamp': Timestamp.now(),
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment status updated to Paid')), // Show confirmation snack bar
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the MPesa confirmation code')), // Show error snack bar if no code entered
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
