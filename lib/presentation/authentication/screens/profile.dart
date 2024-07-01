import 'dart:io';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_2/presentation/authentication/screens/login.dart'; // Import the login page
import 'package:flutter_application_2/screens/view_bookings.dart'; // Import the view bookings page

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _displayName;
  String? _email;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _displayName = user.displayName;
        _email = user.email;
        _profileImageUrl = user.photoURL;
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('${user.uid}.jpg');
          await ref.putFile(File(pickedFile.path));
          final url = await ref.getDownloadURL();

          await user.updatePhotoURL(url);
          setState(() {
            _profileImageUrl = url;
          });
        }
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final newPassword = await _showChangePasswordDialog();
        if (newPassword != null && newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
          print('Password changed successfully');
        }
      } catch (e) {
        print('Error changing password: $e');
      }
    }
  }

  Future<String?> _showChangePasswordDialog() async {
    String? newPassword;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: TextField(
            onChanged: (value) {
              newPassword = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter new password'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Change'),
              onPressed: () {
                Navigator.of(context).pop(newPassword);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page after logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to the login page
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _openViewBookingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewBookingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: Text('Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context), // Pass the context to the _signOut method
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _uploadProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : AssetImage('assets/default_profile_image.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              if (_displayName != null)
                Text(
                  'Name: $_displayName',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 8),
              if (_email != null)
                Text(
                  'Email: $_email',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: Icon(Icons.lock),
                label: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _openViewBookingsPage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book),
                    SizedBox(width: 8),
                    Text(
                      'View Bookings',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
