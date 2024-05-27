import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:flutter_application_2/presentation/home/home_screen.dart';
import 'package:flutter_application_2/providers/auth_provider.dart';
import 'package:flutter_application_2/providers/hotel_provider.dart'; // Import HotelProvider
import 'package:flutter_application_2/presentation/authentication/screens/signup.dart';
import 'package:flutter_application_2/presentation/authentication/screens/login.dart';
import 'package:flutter_application_2/screens/add_hotel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HotelProvider()), // Include HotelProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Set the initial route to '/' for the home page
      initialRoute: '/',
      routes: {
        // Define routes for home, sign up, login screens, and AddHotelScreen
        '/': (context) {
          // Redirect to home page if user is logged in
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return authProvider.isLoggedIn ? HotelListScreen() : const SignUpScreen();
            },
          );
        },
        '/home': (context) => HotelListScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/addHotel': (context) => AddHotelScreen(), // Add route for AddHotelScreen
      },
    );
  }
}
