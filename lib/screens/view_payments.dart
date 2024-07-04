import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class ViewPaymentsPage extends StatefulWidget {
  const ViewPaymentsPage({Key? key}) : super(key: key);

  @override
  _ViewPaymentsPageState createState() => _ViewPaymentsPageState();
}

class _ViewPaymentsPageState extends State<ViewPaymentsPage> {
  late Stream<QuerySnapshot> _paymentsStream;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetching all payments from Firestore
    _paymentsStream = FirebaseFirestore.instance.collection('payments').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Payments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Phone Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _paymentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No payments available.'));
                }

                // Filter payments by phone number
                var filteredPayments = snapshot.data!.docs.where((doc) {
                  var phoneNumber = doc['phoneNumber'] as String;
                  return phoneNumber.contains(_searchQuery);
                }).toList();

                if (filteredPayments.isEmpty) {
                  return Center(child: Text('No payments match the search query.'));
                }

                // Display the list of payments
                return ListView.builder(
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    var payment = filteredPayments[index];
                    var mpesaCode = payment['mpesaCode'];
                    var phoneNumber = payment['phoneNumber'];
                    var amount = payment['amount'];
                    var timestamp = payment['timestamp'] as Timestamp;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Phone Number: $phoneNumber'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MPesa Code: $mpesaCode'),
                            Text('Amount: Ksh $amount'),
                            Text('Timestamp: ${_formatTimestamp(timestamp)}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMM d, yyyy, hh:mm a').format(timestamp.toDate());
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewPaymentsPage(),
  ));
}
