import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String? _email;

  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
  }

  Future<void> _fetchAdminInfo() async {
    try {
      final adminCollection = await FirebaseFirestore.instance.collection('admin').limit(1).get();
      if (adminCollection.docs.isNotEmpty) {
        final adminDoc = adminCollection.docs.first;
        setState(() {
          _email = adminDoc['email'];
        });
      } else {
        print('Admin data not found');
      }
    } catch (e) {
      print('Error fetching admin data: $e');
    }
  }

  Future<void> _changePassword(String newPassword) async {
    if (newPassword.isNotEmpty) {
      try {
        // Encrypt the new password before storing it in Firestore
        String encryptedPassword = sha256.convert(utf8.encode(newPassword)).toString();

        // Update Firestore document with the encrypted password
        await FirebaseFirestore.instance.collection('admin').doc('admin_id').update({
          'password': encryptedPassword,
        });

        // Clear the new password field after successful password change
        _newPasswordController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password changed successfully'),
          duration: Duration(seconds: 2),
        ));
      } catch (e) {
        print('Error changing password: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error changing password'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  void _logout() {
    // Implement your logout logic here, such as clearing user data, navigating to login screen, etc.
    Navigator.pop(context); // Close the admin profile page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_email != null)
                Text(
                  'Email: $_email',
                  style: TextStyle(fontSize: 18),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Change Password'),
                        content: TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                          ),
                          obscureText: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _changePassword(_newPasswordController.text.trim());
                              Navigator.pop(context);
                            },
                            child: Text('Change Password'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
