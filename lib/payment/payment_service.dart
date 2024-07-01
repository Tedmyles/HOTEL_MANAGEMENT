import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  String _convertPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '254${phoneNumber.substring(1)}';
    }
    return phoneNumber;
  }

  Future<Map<String, dynamic>> initiatePayment(String phoneNumber, double amount) async {
    final url = Uri.parse('http://localhost:3000/initiate-payment');
    final convertedPhoneNumber = _convertPhoneNumber(phoneNumber);
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': convertedPhoneNumber,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to initiate payment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<String> checkPaymentStatus(String phoneNumber) async {
    final url = Uri.parse('http://localhost:3000/callback');
    final convertedPhoneNumber = _convertPhoneNumber(phoneNumber);

    while (true) {
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phoneNumber': convertedPhoneNumber}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            return 'paid'; // Return 'paid' if payment is successful
          } else if (responseData['status'] == 'failed') {
            return 'failed'; // Return 'failed' if payment failed
          }
        } else {
          throw Exception('Failed to check payment status: ${response.body}');
        }
      } catch (e) {
        throw Exception('Failed to connect to server: $e');
      }

      await Future.delayed(Duration(seconds: 5)); // Check status every 5 seconds
    }
  }
}
