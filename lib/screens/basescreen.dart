import 'package:flutter/material.dart';
import 'package:online_voting_system/screens/Homes.dart';
import 'package:online_voting_system/screens/Profile.dart'; // Assuming you have a Profile screen
import 'package:online_voting_system/screens/result_screen.dart'; // Assuming you have a Results screen
import 'package:online_voting_system/screens/OngoingElectionScreen.dart'; // Assuming you have a Voting screen

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Homes(),   // Home screen
    // Voting(),  // Voting screen
    // Profile(), // Profile screen
    // Results(), // Results screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed type to display all items
        selectedItemColor: Colors.white,       // Color of the selected item
        unselectedItemColor: Colors.grey,      // Color of the unselected items
        backgroundColor: Colors.blue,          // Background color of the bottom navigation bar
        elevation: 0,                          // No elevation
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),   // Icon for Home screen
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),  // Icon for Voting screen
            label: "Vote",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for Profile screen
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),   // Icon for Results screen
            label: "Results",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
