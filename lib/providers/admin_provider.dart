import 'package:flutter/material.dart'; // Importing necessary Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore for database interactions
import 'package:crypto/crypto.dart'; // Importing crypto package for encryption
import 'dart:convert'; // Importing dart:convert for encoding
import '../presentation/home/admin_screen.dart'; // Import AdminDashboard for navigation

// Define the AdminProvider class which extends ChangeNotifier for state management
class AdminProvider with ChangeNotifier {
  bool _isAdmin = false; // Private variable to track admin status
  bool get isAdmin => _isAdmin; // Public getter for admin status

  // Method to sign in with email and password
  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      // Check admin credentials
      bool adminCheck = await checkAdminCredentials(email, password);
      if (adminCheck) {
        _isAdmin = true; // Set admin status to true if credentials are valid
        notifyListeners(); // Notify listeners about the state change

        // Ensure correct usage of Navigator and type handling
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()), // Navigate to AdminDashboard
          );
        });
      } else {
        _isAdmin = false; // Set admin status to false if credentials are invalid
        _showError(context, 'Invalid admin credentials.'); // Show error message
      }
    } catch (e) {
      _showError(context, 'An error occurred while checking credentials.'); // Show error message on exception
    }
  }

  // Method to check admin credentials
  Future<bool> checkAdminCredentials(String email, String password) async {
    try {
      // Encrypt the password before comparing
      String encryptedPassword = sha256.convert(utf8.encode(password)).toString();

      // Query the admin collection to check credentials
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: encryptedPassword) // Compare with encrypted password
          .get();

      return adminSnapshot.docs.isNotEmpty; // Return true if credentials match
    } catch (e) {
      print('Error checking admin credentials: $e'); // Print error message
      return false; // Return false on exception
    }
  }

  // Method to show error messages using a SnackBar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); // Display SnackBar with error message
  }
}
