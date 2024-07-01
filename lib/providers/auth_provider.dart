import 'package:flutter/material.dart';
import 'package:flutter_application_2/domain/services/auth_service.dart';
import 'package:flutter_application_2/domain/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    UserModel? createdUser = await _authService.createUserWithEmailAndPassword(
        context, email, password);
    if (createdUser != null) {
      _user = createdUser;
      _errorMessage = null;
      _isLoggedIn = true;
      notifyListeners();
    } else {
      _errorMessage = "An error occurred while creating the user.";
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    UserModel? signedInUser =
        await _authService.signInWithEmailAndPassword(context, email, password);
    if (signedInUser != null) {
      _user = signedInUser;
      _errorMessage = null;
      _isLoggedIn = true;
      notifyListeners();
    } else {
      _errorMessage = "Email or password is incorrect.";
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "An error occurred while sending the reset email.";
    }
    notifyListeners();
  }
}
