import 'package:flutter/material.dart';
import 'package:online_voting_system/login.dart';
import 'package:online_voting_system/RegistrationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        color: Colors.blueGrey[800],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              _buildSectionTitle('General Settings'),
              _buildSwitchTile('Notifications', true),
              Divider(color: Colors.blueGrey[600]),
              _buildSwitchTile('Dark Mode', false),
              Divider(color: Colors.blueGrey[600]),
              _buildSectionTitle('Account Settings'),
              Divider(color: Colors.blueGrey[600]),
              _buildListTile('Register', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              }),
              Divider(color: Colors.blueGrey[600]),
              _buildListTile('Sign Out', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (value) {
          // Handle the switch toggle here
        },
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: onTap,
    );
  }
}
