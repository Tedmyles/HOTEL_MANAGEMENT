import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../presentation/home/admin_screen.dart'; // Import AdminDashboard

class AdminProvider with ChangeNotifier {
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      bool adminCheck = await checkAdminCredentials(email, password);
      if (adminCheck) {
        _isAdmin = true;
        notifyListeners();
        // Ensure correct usage of Navigator and type handling
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        });
      } else {
        _isAdmin = false;
        _showError(context, 'Invalid admin credentials.');
      }
    } catch (e) {
      _showError(context, 'An error occurred while checking credentials.');
    }
  }

  Future<bool> checkAdminCredentials(String email, String password) async {
    try {
      // Encrypt the password before comparing
      String encryptedPassword = sha256.convert(utf8.encode(password)).toString();

      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: encryptedPassword) // Compare with encrypted password
          .get();
      return adminSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking admin credentials: $e');
      return false;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
