import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ElectionInformationScreen extends StatefulWidget {
  @override
  _ElectionInformationScreenState createState() =>
      _ElectionInformationScreenState();
}

class _ElectionInformationScreenState extends State<ElectionInformationScreen> {
  User? _user;
  DocumentSnapshot<Map<String, dynamic>>? _userData;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
      _userData = await userDoc.get();
      if (_userData!.exists) {
        setState(() {}); // Update the UI after fetching user data
      } else {
        print('User data not found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error fetching user data (e.g., show error message)
    }
  }

  String? _getUserData(String field) {
    if (_userData != null && _userData!.exists && _userData!.data() != null) {
      return _userData!.data()![field];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Election Name:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '2024 General Election',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Date:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'November 5, 2024',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Location:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Various polling stations across the country',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Voting Hours:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '7:00 AM - 8:00 PM',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Candidates:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Multiple candidates from various political parties',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Additional Information:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Please ensure to bring a valid ID card for verification at the polling station. No electronic devices are allowed inside the polling booth.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            // Display user-specific information if available
            if (_userData != null && _userData!.exists)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'User Information:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Username: ${_getUserData('username') ?? 'N/A'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Email: ${_getUserData('email') ?? 'N/A'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Aadhar No.: ${_getUserData('aadharNo') ?? 'N/A'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
