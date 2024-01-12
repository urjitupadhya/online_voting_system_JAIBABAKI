import 'package:flutter/material.dart';
import 'package:online_voting_system/First.dart';
import 'package:online_voting_system/RegistrationScreen.dart';
import 'package:online_voting_system/Login.dart'; // Import your Login class file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Adjust the theme as needed
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Vote(), // Start with the VotingScreen
        '/registration': (context) => RegistrationScreen(),
        '/login': (context) => Login(), // Add the Login route
      },
    );
  }
}
