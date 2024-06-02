import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'presentation/home/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/hotel_provider.dart';
import 'providers/admin_provider.dart'; // Import AdminProvider
import 'presentation/authentication/screens/signup.dart';
import 'presentation/authentication/screens/login.dart';
import 'presentation/authentication/screens/admin_login_screen.dart'; // Import AdminLoginScreen
import 'screens/add_hotel_screen.dart';
import 'presentation/home/admin_screen.dart'; // Import AdminDashboard
import 'screens/add_room.dart'; // Import AdminAddRoomScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
        ChangeNotifierProvider<HotelProvider>(create: (context) => HotelProvider()),
        ChangeNotifierProvider<AdminProvider>(create: (context) => AdminProvider()), // Add AdminProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return authProvider.isLoggedIn ? HotelListScreen() : const SignUpScreen();
            },
          );
        },
        '/home': (context) => HotelListScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/addHotel': (context) => const AddHotelScreen(),
        '/adminLogin': (context) => const AdminLoginScreen(), // Add route for AdminLoginScreen
        '/adminDashboard': (context) => const AdminDashboard(), // Add route for AdminDashboard
        '/adminAddRoom': (context) => AdminAddRoomScreen(), // Add route for AdminAddRoomScreen
      },
    );
  }
}
