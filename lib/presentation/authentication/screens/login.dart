import 'package:flutter/material.dart';
import 'package:flutter_application_2/presentation/authentication/widgets/logo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/providers/auth_provider.dart';
import 'package:flutter_application_2/presentation/home/home_screen.dart'; // Import the profile screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const LogoWidget(),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white), // Set label color to white
                  prefixIcon: Icon(Icons.email, color: Colors.white), // Email icon with white color
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white), // Set text color to white
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white), // Set label color to white
                  prefixIcon: Icon(Icons.lock, color: Colors.white), // Password icon with white color
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20, // Adjust the height according to your preference
              ),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  // Pass the current context to the AuthProvider
                  await context
                      .read<AuthProvider>()
                      .signInWithEmailAndPassword(context, email, password);
                  // Check if the user is created successfully
                  if (context.read<AuthProvider>().user != null) {
                    // Navigate to the profile screen after successful login
                    Navigator.pushNamed(context, '/profile');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 243, 37), // Change the button color here
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
