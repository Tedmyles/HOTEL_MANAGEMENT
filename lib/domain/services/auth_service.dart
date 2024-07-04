import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication package
import 'package:flutter_application_2/domain/models/user_model.dart'; // Import custom user model
import 'package:awesome_dialog/awesome_dialog.dart'; // Import Awesome Dialog package for error dialogs
import 'package:flutter/material.dart'; // Import Flutter material package

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth instance

  // Create user with email and password
  Future<UserModel?> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      // Try to create a new user with the provided email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user; // Get the created user
      return UserModel(uid: user?.uid, email: user?.email); // Return user details as UserModel
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      String errorMessage = '';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        default:
          errorMessage = 'An error occurred while creating the user.';
      }
      // Show an AwesomeDialog with the error message
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
      return null; // Return null if there was an error
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      // Try to sign in with the provided email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user; // Get the signed-in user
      return UserModel(uid: user?.uid, email: user?.email); // Return user details as UserModel
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      String errorMessage = '';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage = 'An error occurred while signing in.';
      }
      // Show an AwesomeDialog with the error message
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
      return null; // Return null if there was an error
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Try to send a password reset email to the provided email address
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow; // Throw the error back to the caller for handling
    }
  }
}
