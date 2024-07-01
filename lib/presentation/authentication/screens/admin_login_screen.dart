import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:flutter_application_2/providers/admin_provider.dart'; 

// Define a stateful widget for the Admin Login Screen.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

// Define the state for the Admin Login Screen.
class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controller for the email input field.
  final TextEditingController _passwordController = TextEditingController(); // Controller for the password input field.

  // Dispose of the controllers when the widget is disposed.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Build the UI for the Admin Login Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent, 
      appBar: AppBar(
        title: const Text('Admin Login'), 
        backgroundColor: Colors.deepPurpleAccent, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body content.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column's content vertically.
          children: [
            // Email input field
            TextFormField(
              controller: _emailController, // Attach the email controller to the input field.
              decoration: const InputDecoration(
                labelText: 'Email', // Set the label text.
                prefixIcon: Icon(Icons.email, color: Colors.white), // Add an email icon prefix.
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the border radius.
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the enabled border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the enabled border radius.
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the focused border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the focused border radius.
                ),
                labelStyle: TextStyle(color: Colors.white), // Set the label text color.
              ),
              style: TextStyle(color: Colors.white), // Set the input text color.
            ),
            const SizedBox(height: 16), // Add vertical space between the fields.
            // Password input field
            TextFormField(
              controller: _passwordController, // Attach the password controller to the input field.
              decoration: const InputDecoration(
                labelText: 'Password', // Set the label text.
                prefixIcon: Icon(Icons.lock, color: Colors.white), // Add a lock icon prefix.
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the border radius.
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the enabled border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the enabled border radius.
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set the focused border color.
                  borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set the focused border radius.
                ),
                labelStyle: TextStyle(color: Colors.white), // Set the label text color.
              ),
              style: TextStyle(color: Colors.white), // Set the input text color.
              obscureText: true, // Hide the input text for password fields.
            ),
            const SizedBox(height: 20), // Add vertical space before the button.
            // Login button
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim(); // Get and trim the email input.
                String password = _passwordController.text.trim(); // Get and trim the password input.
                await context.read<AdminProvider>().signInWithEmailAndPassword(context, email, password); // Call the sign-in method from the provider.
                // No need to check if the user is admin here, signInWithEmailAndPassword handles it.
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.deepPurpleAccent), // Set the button text color.
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurpleAccent, // Set the button foreground color.
                backgroundColor: Colors.white, // Set the button background color.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set the button border radius.
                ),
                padding: EdgeInsets.symmetric(vertical: 12), // Set the button padding.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
