import 'package:flutter/material.dart';
import 'package:flutter_application_2/presentation/authentication/widgets/logo.dart';
import 'package:flutter_application_2/providers/auth_provider.dart' as custom;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to send a password reset email
  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the back button in the app bar
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const LogoWidget(), // Custom logo widget
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Email', // Label text
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  prefixIcon: Icon(Icons.email, color: Colors.white), // Email icon
                ),
              ),
              const SizedBox(height: 16), // Vertical spacing
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Password', // Label text
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  prefixIcon: Icon(Icons.lock, color: Colors.white), // Lock icon
                ),
                obscureText: true, // Hide password characters
              ),
              const SizedBox(height: 20), // Vertical spacing
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim(); // Get trimmed email
                  String password = _passwordController.text.trim(); // Get trimmed password
                  await context.read<custom.AuthProvider>().signInWithEmailAndPassword(context, email, password); // Call signInWithEmailAndPassword from AuthProvider
                  if (context.read<custom.AuthProvider>().user != null) {
                    Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen if user is authenticated
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 243, 37), // Button background color
                ),
                child: const Text('Login'), // Button text
              ),
              const SizedBox(height: 20), // Vertical spacing
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/adminLogin'); // Navigate to admin login screen
                },
                child: const Text('Login as Admin', style: TextStyle(color: Colors.white)), // Admin login text
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp'); // Navigate to sign up screen
                },
                child: const Text("Don't have an account? Signup", style: TextStyle(color: Colors.white)), // Signup text
              ),
              TextButton(
                onPressed: () async {
                  String email = _emailController.text.trim(); // Get trimmed email
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your email address.')), // Show snackbar if email is empty
                    );
                  } else {
                    await _sendPasswordResetEmail(email); // Call _sendPasswordResetEmail method
                  }
                },
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.purple)), // Forgot password text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
