import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  Future<Map<String, dynamic>> initiatePayment(String phoneNumber, double amount) async {
    final url = Uri.parse('http://localhost:3000/initiate-payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'amount': amount.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Assuming the response body contains a JSON object
    } else {
      throw Exception('Failed to initiate payment: ${response.body}');
    }
  }

  Future<String> checkPaymentStatus(String phoneNumber) async {
    final url = Uri.parse('http://localhost:3000/check-payment-status');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Assuming response.body contains payment status
    } else {
      throw Exception('Failed to check payment status: ${response.body}');
    }
  }
}
