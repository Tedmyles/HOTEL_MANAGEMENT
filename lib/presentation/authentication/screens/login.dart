import 'package:flutter/material.dart'; // Import the Flutter Material package.
import 'package:flutter_application_2/presentation/authentication/widgets/logo.dart'; // Import the custom logo widget.
import 'package:flutter_application_2/providers/auth_provider.dart'; // Import the authentication provider for state management.
import 'package:provider/provider.dart'; // Import the Provider package for state management.
import 'package:flutter_application_2/presentation/home/home_screen.dart'; // Import the home screen.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Controller for the email input field.
  final _passwordController = TextEditingController(); // Controller for the password input field.

  @override
  void dispose() {
    _emailController.dispose(); // Dispose the email controller when the widget is disposed.
    _passwordController.dispose(); // Dispose the password controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow in the app bar.
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'), // Set the background image.
            fit: BoxFit.cover, // Cover the entire background with the image.
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the body content.
          child: Column(
            children: [
              const LogoWidget(), // Add the custom logo widget.
              TextFormField(
                controller: _emailController, // Attach the email controller to the input field.
                style: const TextStyle(color: Colors.white), // Set the input text color.
                decoration: const InputDecoration(
                  labelText: 'Email', // Set the label text.
                  labelStyle: TextStyle(color: Colors.white), // Set the label text color.
                  prefixIcon: Icon(Icons.email, color: Colors.white), // Add an email icon prefix.
                ),
              ),
              const SizedBox(height: 16), // Add vertical space between the fields.
              TextFormField(
                controller: _passwordController, // Attach the password controller to the input field.
                style: const TextStyle(color: Colors.white), // Set the input text color.
                decoration: const InputDecoration(
                  labelText: 'Password', // Set the label text.
                  labelStyle: TextStyle(color: Colors.white), // Set the label text color.
                  prefixIcon: Icon(Icons.lock, color: Colors.white), // Add a lock icon prefix.
                ),
                obscureText: true, // Hide the input text for password fields.
              ),
              const SizedBox(height: 20), // Add vertical space before the button.
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim(); // Get and trim the email input.
                  String password = _passwordController.text.trim(); // Get and trim the password input.
                  await context.read<AuthProvider>().signInWithEmailAndPassword(context, email, password); // Call the sign-in method from the provider.
                  if (context.read<AuthProvider>().user != null) { // Check if the user is successfully signed in.
                    Navigator.pushReplacementNamed(context, '/home'); // Navigate to the home screen and replace the current screen.
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 243, 37), // Set the button background color.
                ),
                child: const Text('Login'), // Set the button text.
              ),
              const SizedBox(height: 20), // Add vertical space before the admin login button.
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/adminLogin'); // Navigate to the admin login screen.
                },
                child: const Text('Login as Admin', style: TextStyle(color: Colors.white)), // Set the admin login button text and color.
              ),
              // Add a text button to navigate to the signup screen.
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp'); // Navigate to the signup screen.
                },
                child: const Text("Don't have an account? Signup"), // Set the signup button text.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
