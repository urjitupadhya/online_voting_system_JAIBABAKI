import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

String voter_private_key = '';
String hash_number = '';

void getPrivateKeys() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the current user's node in the database
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users').child(user.uid);

      // Fetch the user's data once
      DataSnapshot snapshot =
          await userRef.once().then((snapshot) => snapshot.snapshot);

      // Extract the private key and hash number from the snapshot
      Map<dynamic, dynamic>? userData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        String? privateKey = userData['privateKey'];
        String? hashNumber = userData['hashNumber']; // Add this line

        if (privateKey != null && privateKey.isNotEmpty) {
          // Assign the private key and hash number to the global variables
          voter_private_key = privateKey;
          hash_number = hashNumber ?? ''; // Assign hash number or empty string if null
          print('Private key obtained successfully: $voter_private_key');
          print('Hash number obtained successfully: $hash_number');
        } else {
          print('Private key not found for the current user.');
        }
      } else {
        print(
            'No data available for the current user or data format is incorrect.');
      }
    } else {
      print('User is not logged in.');
    }
  } catch (e) {
    print('Error fetching private key: $e');
  }
}

void main() {
  // Call the function to get the private key
  getPrivateKeys();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactUsScreen(),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call the function to get the private key
    getPrivateKeys();

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      //   body: ContactUsForm(),
    );
  }
}
