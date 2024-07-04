import 'package:flutter/material.dart';
import 'package:flutter_application_2/domain/services/auth_service.dart';
import 'package:flutter_application_2/domain/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService(); // Instance of AuthService to handle authentication
  UserModel? _user; // UserModel to hold the authenticated user's information
  String? _errorMessage; // String to hold any error messages
  bool _isLoggedIn = false; // Boolean to track if the user is logged in

  // Getters to expose private fields
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Method to create a user with email and password
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    UserModel? createdUser = await _authService.createUserWithEmailAndPassword(
        context, email, password);
    if (createdUser != null) {
      _user = createdUser; // Set the user if creation is successful
      _errorMessage = null; // Clear any error messages
      _isLoggedIn = true; // Set logged in status to true
      notifyListeners(); // Notify listeners of state change
    } else {
      _errorMessage = "An error occurred while creating the user."; // Set error message
      _isLoggedIn = false; // Set logged in status to false
      notifyListeners(); // Notify listeners of state change
    }
  }

  // Method to sign in a user with email and password
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    UserModel? signedInUser =
        await _authService.signInWithEmailAndPassword(context, email, password);
    if (signedInUser != null) {
      _user = signedInUser; // Set the user if sign in is successful
      _errorMessage = null; // Clear any error messages
      _isLoggedIn = true; // Set logged in status to true
      notifyListeners(); // Notify listeners of state change
    } else {
      _errorMessage = "Email or password is incorrect."; // Set error message
      _isLoggedIn = false; // Set logged in status to false
      notifyListeners(); // Notify listeners of state change
    }
  }

  // Method to send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email); // Attempt to send reset email
      _errorMessage = null; // Clear any error messages
    } catch (e) {
      _errorMessage = "An error occurred while sending the reset email."; // Set error message
    }
    notifyListeners(); // Notify listeners of state change
  }
}
