import 'package:http/http.dart' as http; // Import the http package for making HTTP requests
import 'dart:convert'; // Import the dart:convert library for encoding and decoding JSON

class PaymentService {
  // Convert a phone number to the international format by replacing the leading '0' with '254'
  String _convertPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '254${phoneNumber.substring(1)}';
    }
    return phoneNumber;
  }

  // Initiate a payment by sending a POST request to the server with the phone number and amount
  Future<Map<String, dynamic>> initiatePayment(String phoneNumber, double amount) async {
    final url = Uri.parse('http://localhost:3000/initiate-payment'); // Server URL for initiating payment
    final convertedPhoneNumber = _convertPhoneNumber(phoneNumber); // Convert phone number to international format
    
    try {
      // Send POST request to the server
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // Set the content type to JSON
        body: jsonEncode({
          'phoneNumber': convertedPhoneNumber,
          'amount': amount,
        }),
      );

      // If the response status code is 200, decode and return the response body
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // If the response status code is not 200, throw an exception with the response body
        throw Exception('Failed to initiate payment: ${response.body}');
      }
    } catch (e) {
      // If an error occurs, throw an exception with the error message
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Check the payment status by sending a POST request to the server with the phone number
  Future<String> checkPaymentStatus(String phoneNumber) async {
    final url = Uri.parse('http://localhost:3000/callback'); // Server URL for checking payment status
    final convertedPhoneNumber = _convertPhoneNumber(phoneNumber); // Convert phone number to international format

    while (true) {
      try {
        // Send POST request to the server
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'}, // Set the content type to JSON
          body: jsonEncode({'phoneNumber': convertedPhoneNumber}),
        );

        // If the response status code is 200, decode the response body and check the payment status
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            return 'paid'; // Return 'paid' if payment is successful
          } else if (responseData['status'] == 'failed') {
            return 'failed'; // Return 'failed' if payment failed
          }
        } else {
          // If the response status code is not 200, throw an exception with the response body
          throw Exception('Failed to check payment status: ${response.body}');
        }
      } catch (e) {
        // If an error occurs, throw an exception with the error message
        throw Exception('Failed to connect to server: $e');
      }

      await Future.delayed(Duration(seconds: 5)); // Check status every 5 seconds
    }
  }
}
